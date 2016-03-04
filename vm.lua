
require 'vm_instr'

function run()

    -- push current ip value on the call stack; jump to the address in index 2 
    if c_instr[1] == instr.call_word then

    -- pop from data stack and check to see if it's tagged as a word
    -- if it is tagged as a word then perform call word
    -- else panic
    elseif c_instr[1] == instr.call_word_on_stack then 

    -- try to look up the lua function in index 2 (will be a key)
    -- if the function can be found call it otherwise panic
    elseif c_instr[1] == instr.call_primitive then 

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


