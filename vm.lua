
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

    while ip <= #instr_array do

        local c_instr = instr_array[ ip ]

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

        elseif c_instr[1] == instr.if_statement then

            local false_case_present, false_case = data_stack:pop()
            if not false_case_present then
                panic "false case was not present for if-statement"
            end
            if false_case.tag ~= vm_obj_tag.word then
                panic( "value in false_case position was not word:  " .. false_case.tag )
            end

            local true_case_present, true_case = data_stack:pop()
            if not true_case_present then
                panic "true case was not present for if-statement"
            end
            if true_case.tag ~= vm_obj_tag.word then
                panic( "value in true_case position was not word:  " .. true_case.tag )
            end

            local bool_present, bool = data_stack:pop()
            if not bool_present then
                panic "boolean value was not present for if-statement"
            end
            if bool.tag ~= vm_obj_tag.bool then
                panic( "value in boolean position was not boolean:  " .. bool.tag )
            end

            call_stack:push( ip + 1 )
            if bool.value then
                ip = true_case.value 
            else
                ip = false_case.value 
            end

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
            
    end

    return data_stack

end

