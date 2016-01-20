

--[[ 


it would be nice if we can save all of the instructions in the same memory block
so that a stack frame can just have a return index for the instruction pointer
then we just need a way to flag the difference between an instruction which is a 
pointer to another word or a primitive action
-- what i mean by memory block is that all of the instructions that make
-- up a words definitions are in an array and each word definition has
-- a known starting address



call defined word
call primitive function
call word on stack
pop 
push X
dup ( a -- a a )
drop ( a -- )
swap ( a b -- b a )
over ( a b -- a b a )
rot ( a b c -- b c a )
-rot ( a b c -- c a b )

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
create new stack entry with return address, move ip to new address, back to vm


what should call primitive do?
grab function from collection, then either ( reflect inputs, place in function, call function, get outputs on stack, back to vm)
OR pass stack object to function, then back to vm

step one parse into ast
step two create dictionary with all of the word definitions
step three create instructions array with all word definitions and a lookup table of words to their starting point
    in the instruction array
step four you can swap out word names with the addresses in the lookup table (might be a one pass solution?)
step five start program at well known address point


--]]
local func_stack = {}
