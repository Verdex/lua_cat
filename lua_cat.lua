

-- word_addresses : the index in the dictionary where the word is found
-- word : [word_addresses | primitive function]

--[[ 


it would be nice if we can save all of the instructions in the same memory block
so that a stack frame can just have a return index for the instruction pointer
then we just need a way to flag the difference between an instruction which is a 
pointer to another word or a primitive action


call defined word
call primitive function
call word on stack
pop 
push X
<what else?>


primitive functions can take a single paramter which is a stack object
it would be better though if I can reflect the number of input parameters and 
return values and automatically handle that


parsing
parse word
parse lambda
parse number or string
parse comment
define word


what should call word do?


what should call primitive do?
grab function from collection, then either ( reflect inputs, place in function, call function, get outputs on stack, back to vm)
OR pass stack object to function, then back to vm


--]]
local func_stack = {}
