
--[[
parsing
define lua function
--]]



function make_stream(content)
    local ret = { index = 1, content = content or "" }
    ret.copy = function ( self )
        local ret = make_stream(self.content)
        ret.index = self.index
        return ret
    end
    ret.get = function (self)
        if self.index > #self.content then
            return nil
        end

        local ret = self.content:sub( self.index, self.index )
        self.index = self.index + 1

        return ret
    end
    ret.back = function ( self )
        if self.index > 1 then
            self.index = self.index - 1
        end
    end
    return ret
end

function remove_spaces( stream )
    local g = stream:get()
    while g and string.match( g, "%s" ) do
        g = stream:get()
    end
    if g then
        stream:back()
    end
    return true, stream
end

function parse_word( stream )
    local first = stream:get()
    local pattern = '[%s%[%]%"%(%);]' 
    if not first or string.match( first, pattern ) then
        return nil
    end
    local t = { first }
    local tlet = stream:get()
    while tlet and not string.match( tlet, pattern ) do
        table.insert( t, tlet )
        tlet = stream:get()
    end
    if tlet then
        stream:back()
    end
    return { tag = "word"; value = table.concat( t ) }, stream
end

function parse_boolean( stream )
    local t = bind( match_char( "t" ), function () return
              bind( match_char( "r" ), function () return
              bind( match_char( "u" ), function () return
              bind( match_char( "e" ), function () return
              unit( { tag = "boolean"; value = true } ) end ) end ) end ) end )

    local f = bind( match_char( "f" ), function () return
              bind( match_char( "a" ), function () return
              bind( match_char( "l" ), function () return
              bind( match_char( "s" ), function () return
              bind( match_char( "e" ), function () return
              unit( { tag = "boolean"; value = false } ) end ) end ) end ) end ) end )

    return alt( t, f )( stream )
end

function parse_bracketed( start_sym, end_sym, stream )
    local first = stream:get()
    if first ~= start_sym then
        return nil
    end
    local t = {}
    local tlet = stream:get()
    while tlet ~= end_sym do
        if tlet == nil then
            return nil
        end
        table.insert( t, tlet )
        tlet = stream:get()
    end
    return table.concat( t ), stream
end

function parse_string( stream )
    local value, stream = parse_bracketed( '"', '"', stream )
    if value then
        return { tag = "string"; value = value }, stream
    end
    return nil
end

function parse_comment( stream )
    local value, stream = parse_bracketed( '(', ')', stream )
    if value then
        return { tag = "comment", value = value }, stream
    end
    return nil
end

function parse_top_level( stream )
    local f = function ( p ) return bind( p, function ( v ) return 
                                    bind( remove_spaces, function () return
                                    unit( v ) end ) end )
              end
    return 
           bind( remove_spaces, function () return 
           bind( zero_or_more( alt( f( parse_definition ), f( parse_comment ) ) ), function ( vs ) return
           bind( remove_spaces, function () return
           bind( is_end, function () return
           unit( { tag = "top", value = vs } ) end ) end ) end ) end )( stream )
end

function parse_definition( stream )
    return bind( match_char ":", function () return
           bind( remove_spaces, function () return
           bind( parse_word, function ( name ) return
           bind( remove_spaces, function () return
           bind( zero_or_more( parse_word_body_element ), function ( body ) return
           bind( remove_spaces, function () return
           bind( match_char ";", function () return
           unit( { tag = "definition"; name = name.value; body = body } ) end ) end ) end ) end ) end ) end ) end )( stream )
end

function parse_word_body_element( stream )
    local f = function ( p ) return bind( p, function ( v ) return 
                                    bind( remove_spaces, function () return
                                    unit( v ) end ) end )
              end

    return alt( f( parse_comment ), 
                f( parse_string ), 
                f( parse_num ), 
                f( parse_boolean ),
                f( parse_word ), 
                f( parse_lambda ) )( stream )
end

function parse_lambda( stream )  
    return bind( match_char "[", function () return
           bind( remove_spaces, function () return
           bind( zero_or_more( parse_word_body_element ), function ( v ) return
           bind( match_char "]", function () return
           unit( { tag = "lambda"; value = v } ) end ) end ) end ) end )( stream )
end
   
function parse_num( stream )
    local first = stream:get()
    if not tonumber( first ) then
        return nil
    end
    local t = { first }
    local o = stream:get()
    while tonumber( o ) do
        table.insert( t, o )
        o = stream:get()
    end
    if o == nil or not string.match( o, "%s" ) then
        return nil
    end
    stream:back()
    local stringy = table.concat( t )
    return { tag = "number"; value = tonumber( stringy ) }, stream
end

function is_end( stream )
    if stream:get() then
        return nil
    end
    return true, stream
end

-- parser = stream -> (value, stream)
-- parser -> ( value -> parser ) -> parser
function bind( parser, gen )
    return function ( stream )
        local value, stream2 = parser( stream:copy() )
        if value then
            return gen( value )( stream2:copy() )
        end
        return nil
    end
end

function unit( v ) 
    return function( stream )
        return v, stream
    end
end

-- [parser] -> parser
function alt( ... )
    local t = { ... }
     
    return function ( stream )
        local index = 1
        repeat
            local value, stream2 = t[index]( stream:copy() )
            if value then
                return value, stream2 
            end
            index = index + 1
        until index > #t
        return nil
    end
end

-- parser a -> parser [a]
function one_or_more( parser )
    return function( stream )
        local value, stream2 = parser( stream:copy() )
        if not value then
            return nil
        end
        local t = { value }
        local temp = stream2
        repeat
            value, stream2 = parser( stream2:copy() ) 
            if value then
                table.insert( t, value )
                temp = stream2
            end
        until not value
        return t, temp 
    end
end

function zero_or_more( parser )
    local n = function( stream ) return true, stream end
    return alt( one_or_more( parser ), n )
end

function match_char( char )
    return function( stream )
        local first = stream:get()
        if first ~= char then
            return nil
        end
        return first, stream
    end
end

function consume_until( parser, end_parser )
    return function ( stream )
        local t = {}
        local end_value, ret_stream = end_parser( stream:copy() )
        while not end_value do
            local value, stream2 = parser( stream )
            if not value then
                return nil
            end
            stream = stream2
            table.insert( t, value )
            end_value, ret_stream = end_parser( stream2:copy() )
        end
        return t, ret_stream
    end
end

