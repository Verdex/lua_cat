
--module( ..., package.seeall )
--[[
parsing
parse word
parse lambda
parse number or string
parse comment
define word
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


-- remember to make an alternate method for these guys

function remove_spaces( stream )
    while string.match( stream:get(), "%s" ) do
    end
    stream:back()
    return true, stream
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
    return tonumber( stringy ), stream
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
     
