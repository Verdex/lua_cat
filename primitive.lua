
-- dup : ( a -- a a )
local function dup( data_stack, vm )
    local success, v = data_stack:pop()
    if not success then
        -- TODO how am I going to handle errors? (panic of some sort?)
        -- if it's a panic don't I need to trigger it somehow?
        -- call vm.panic() ?
    end

    data_stack:push( v:copy() )
    data_stack:push( v )

end

-- drop : ( a -- )
local function drop( data_stack, vm )
    local success, v = data_stack:pop()
    if not success then
        -- TODO panic
    end
end

-- swap : ( a b -- b a )
local function swap( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 or not s2 then
        -- TODO panic
    end

    data_stack:push( v2 )
    data_stack:push( v1 )

end

-- over : ( a b -- a b a )
local function over( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 or not s2 then
        -- TODO panic
    end

    data_stack:push( v1:copy() )
    data_stack:push( v2 )
    data_stack:push( v1 )

end

primitive_key = {
    dup = "dup key",
    drop = "drop key",
    swap = "swap key",
    over = "over key",
}

primitive_word = { 
    [ primitive_key.dup ] = dup,
    [ primitive_key.drop ] = drop,
    [ primitive_key.swap ] = swap,
    [ primitive_key.over ] = over,
}

