
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

    local a_part = table.concat( t, " " )
    if a_part ~= "" and r_part ~= "" then
        return string.format( "-| %s %s |-", r_part, "[ " .. a_part .. " ]" )
    elseif a_part ~= "" then
        return "[ " .. a_part .. " ]"
    elseif r_part ~= "" then
        return r_part 
    else
        return "()"
    end
end
        
