

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

--]]
local func_stack = {}
