
--[[

    index 1 = op code
    index 2 = param 1
    index 3 = param 2
    ...

--]]

--[[ 

    tag = type info
    value = value

--]]

instr = {

    --[[ put the current ip address on the call stack and 
         jump to the address in index 2
    --]]
    call_word = "call_word_instruction",

    --[[ pop the data stack and check to see if it's tagged as a word
         if it is then perform the call word procedure
         if it isn't then panic
    --]]
    call_word_on_stack = "call_word_on_stack_instruction",

    --[[ try to look up the lua function in index 2
         if the function can be found call it
         if the function can't be found then panic
    --]]
    call_primitive = "call_primitive_instruction",

    --[[ tag the number in index 2 and push it onto the stack
    --]]
    push_number = "push_number_instruction", 

    --[[ tag the string in index 2 and push it onto the stack
    --]]
    push_string = "push_string_instruction",

    --[[ tag the word address in index 2 and push it onto the stack
    --]]
    push_word = "push_word_instruction", 

    --[[ tag the boolean in index 2 and push it onto the stack
    --]]
    push_bool = "push_bool_instruction", 

    --[[ return
    --]]
    ret = "return_instruction",
}

