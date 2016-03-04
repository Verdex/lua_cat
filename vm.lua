
require 'vm_instr'
require 'vm_obj'
require 'primitive'
require 'stack'

-- TODO need a vm object that has vm operations that we pass to primitive functions

function run( instr_array )

    local data_stack = stack_create()
    local call_stack = stack_create()
    local ip = 1

    while ip <= #instr_array do

        local c_instr = instr_array[ ip ]

        -- push current ip value on the call stack; jump to the address in index 2 
        if c_instr[1] == instr.call_word then

        -- pop from data stack and check to see if it's tagged as a word
        -- if it is tagged as a word then perform call word
        -- else panic
        elseif c_instr[1] == instr.call_word_on_stack then 

        -- try to look up the lua function in index 2 (will be a key)
        -- if the function can be found call it otherwise panic
        elseif c_instr[1] == instr.call_primitive then 
            local w = primitive_word[ c_instr[2] ]
            if w then
                -- call word (not sure about params)
            else
                -- panic
            end

        -- tag the number in index 2 and push it onto the data stack
        elseif c_instr[1] == instr.push_number then 

        -- tag the string in index 2 and push it onto the data stack
        elseif c_instr[1] == instr.push_string then 
       
        -- tag the word in index 2 and push it onto the data stack
        elseif c_instr[1] == instr.push_word then 

        -- tag the bool in index 2 and push it onto the data stack
        elseif c_instr[1] == instr.push_bool then 

        -- pop the call stack and set the value to ip
        elseif c_instr[1] == instr.ret then 

        else 
            -- panic
        end
            
    end

end


