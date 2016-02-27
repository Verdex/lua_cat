
require 'seq'

function display( t )
    if type( t ) ~= "table" then
        return tostring( t )
    end
    local records = {}
    for k, v in pairs( t ) do
        if type( k ) ~= "number" then
            table.insert( records, { k, v } )
        end
    end
    local r_part = "" 
    if #records > 0 then
        local r = fold( function( a, b ) return a .. " " .. tostring( b[1] ) .. " = " .. display( b[2] ) end, "", records )
        r_part = "{" .. r .. " }"
    end

    local array = {}
    for _, v in ipairs( t ) do
        table.insert( array, v )
    end
    local a_part = "" 
    if #array > 0 then
        a_part = fold( function( s, v ) return s .. " " .. display( v ) end, "", array ) 
    end
    
    if a_part ~= "" and r_part ~= "" then
        return string.format( "-| %s %s |-", r_part, "[ " .. a_part .. " ]" )
    elseif a_part ~= "" then
        return "[" .. a_part .. " ]"
    elseif r_part ~= "" then
        return r_part 
    else
        return "()"
    end
end

function concat( t1, t2 )
    local t = {}
    for _, v in ipairs( t1 ) do
        table.insert( t, v )
    end
    for _, v in ipairs( t2 ) do
        table.insert( t, v )
    end
    return t
end
