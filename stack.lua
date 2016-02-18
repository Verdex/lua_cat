
local function push( self, value )
    table.insert( self, 1, value )
end

local function pop( self )
    if #self == 0 then
        return false
    else
        return true, table.remove( self, 1 )
    end
end


function stack_create()
    return { tag = "stack"; pop = pop; push = push }
end

