
require 'vm_instr'
require 'vm_obj'
require 'primitive'
require 'stack'

require 'util'

local function panic( msg )
    error( msg or "PANIC" )
end

function run( instr_array )

    local data_stack = stack_create()
    local call_stack = stack_create()
    local ip = 1
    local vm = { panic = panic }


    -- TODO remove print( display( instr_array ) )

    -- TODO remove if true then return end

    while ip <= #instr_array do

        local c_instr = instr_array[ ip ]

        -- TODO remove print( ip, c_instr[1], c_instr[2] )

        if c_instr[1] == instr.call_word then
            call_stack:push( ip + 1 )
            ip = c_instr[2]

        elseif c_instr[1] == instr.call_word_on_stack then 
            local value_present, value = data_stack:pop()
            if not value_present then
                panic "no data on stack when trying to call word on stack"
            end
            if value.tag ~= vm_obj_tag.word then
                panic "Attempting to call non word on stack"
            end
            call_stack:push( ip + 1 )
            ip = value.value 

        elseif c_instr[1] == instr.call_primitive then 
            local w = primitive_word[ c_instr[2] ]
            if w then
                w( data_stack, vm )
            else
                panic( "Unknown primitive word: " .. c_instr[2] )
            end
            ip = ip + 1

        elseif c_instr[1] == instr.push_number then 
            local v = create_vm_obj(vm_obj_tag.number, c_instr[2])
            data_stack:push( v )
            ip = ip + 1

        elseif c_instr[1] == instr.push_string then 
            local v = create_vm_obj(vm_obj_tag.string, c_instr[2])
            data_stack:push( v )
            ip = ip + 1
       
        elseif c_instr[1] == instr.push_word then 
            local v = create_vm_obj(vm_obj_tag.word, c_instr[2])
            data_stack:push( v )
            ip = ip + 1

        elseif c_instr[1] == instr.push_bool then 
            local v = create_vm_obj(vm_obj_tag.bool, c_instr[2])
            data_stack:push( v )
            ip = ip + 1

        elseif c_instr[1] == instr.ret then 
            local value_present, value = call_stack:pop()
            if not value_present then
                -- end of program
                break
            end
            ip = value

        else 
            panic( "Unknown instruction: " .. c_instr[1] )
        end

        --TODO remove io.read()
            
    end

    return data_stack

end

