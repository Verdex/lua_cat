
require 'vm_obj'

-- TODO still need math, if

-- if : ( bool lambda lambda -- ? )

local function p( data_stack, vm )
    local success, v = data_stack:pop()
    if not success then
        vm.panic( "print failed because there is no data on the stack" )
    end
    
    if v.tag == vm_obj_tag.number then
        print( v.value )
    elseif v.tag == vm_obj_tag.string then
        print( v.value )
    elseif v.tag == vm_obj_tag.bool then
        print( v.value )
    elseif v.tag == vm_obj_tag.word or v.tag == vm_obj_tag.primitive_word then
        print( "WORD" )
    end
end

local function add_num( data_stack, vm ) 
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 and not s2 then
        vm.panic( "add_num failed because there is no data on stack" )
    end
    if v1.tag ~= vm_obj_tag.number then
        vm.panic( "add_num failed because the item on the stack was not a number:  " .. v1.tag )
    end
    if v2.tag ~= vm_obj_tag.number then
        vm.panic( "add_num failed because the item on the stack was not a number:  " .. v2.tag )
    end

    data_stack:push( create_vm_obj( vm_obj_tag.number,  v1.value + v2.value ) )
end

local function sub_num( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 and not s2 then
        vm.panic( "sub_num failed because there is no data on stack" )
    end
    if v1.tag ~= vm_obj_tag.number then
        vm.panic( "sub_num failed because the item on the stack was not a number:  " .. v1.tag )
    end
    if v2.tag ~= vm_obj_tag.number then
        vm.panic( "sub_num failed because the item on the stack was not a number:  " .. v2.tag )
    end

    data_stack:push( create_vm_obj( vm_obj_tag.number, v2.value - v1.value ) )
end

local function equal_num( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 and not s2 then
        vm.panic( "equal_num failed because there is no data on stack" )
    end
    if v1.tag ~= vm_obj_tag.number then
        vm.panic( "equal_num failed because the item on the stack was not a number:  " .. v1.tag )
    end
    if v2.tag ~= vm_obj_tag.number then
        vm.panic( "equal_num failed because the item on the stack was not a number:  " .. v2.tag )
    end

    data_stack:push( create_vm_obj( vm_obj_tag.bool, v2.value == v1.value ) )
end

-- dup : ( a -- a a )
local function dup( data_stack, vm )
    local success, v = data_stack:pop()
    if not success then
        vm.panic( "dup failed because there is no data on the stack" )
    end

    data_stack:push( v:copy() )
    data_stack:push( v )

end

-- drop : ( a -- )
local function drop( data_stack, vm )
    local success, v = data_stack:pop()
    if not success then
        vm.panic( "drop failed because there is no data on the stack" )
    end
end

-- swap : ( a b -- b a )
local function swap( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 or not s2 then
        vm.panic( "swap failed because there is no data on the stack" )
    end

    data_stack:push( v2 )
    data_stack:push( v1 )

end

-- over : ( a b -- a b a )
local function over( data_stack, vm )
    local s1, v1 = data_stack:pop()
    local s2, v2 = data_stack:pop()
    if not s1 or not s2 then
        vm.panic( "over failed because there is no data on the stack" )
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
    print = "print key",
    add_num = "add num key",
    sub_num = "sub num key",
    equal_num = "equal num key",
}

primitive_word = { 
    [ primitive_key.dup ] = dup,
    [ primitive_key.drop ] = drop,
    [ primitive_key.swap ] = swap,
    [ primitive_key.over ] = over,
    [ primitive_key.print ] = p,
    [ primitive_key.add_num ] = add_num,
    [ primitive_key.sub_num ] = sub_num,
    [ primitive_key.equal_num ] = equal_num,
}

