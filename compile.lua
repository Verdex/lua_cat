

require 'seq'
require 'vm_instr'
require 'primitive'
require 'util'
-- input is an ast and the output is ... a list of instructions for the vm


--[[ foreach definition we need a list of instructions, then we smach everything in one list
     then we can go through all of those instructions blocks and replace word names with word addresses

--]]
-- ast -> instruction list
function compile( ast )

    if ast.tag ~= "top" then
        error "compile needs to be passed an AST with a top level node"
    end

    -- ast.value is a list of comments and definitions
    -- get rid of comments
    local defs = filter( function( a ) return a.tag ~= "comment" end, ast.value )

    -- Action:  Flag error if we see something that's not a definition in the top level
    for _, v in ipairs( defs ) do
        if v.tag ~= "definition" then
            error "compiler top level contains non definition or non comment node"
        end
    end


end

--[[
    code block 
--]]
function cblock_cons( name, list_of_instr )
    return { name = name; instr = list_of_instr }
end

--[[
    A p block is a unit that a process_* method will return
--]]
function pblock_cons( list_of_instr, list_of_cblock )
    return { instr = list_of_instr, cblock = list_of_cblock }
end

function pblock_join( a, b )
    local instr = concat( a.instr, b.instr )
    local blocks = concat( a.cblock, b.cblock )
    return pblock_cons( instr, blocks )
end

local gs_index = 0
function gensym()
    gs_index = gs_index + 1
    return "anon_method_" .. gs_index
end


function process_def( def )
end

-- take lambda ast node return an anonomous word def block (need gensym) AND a push word onto 
-- stack opcode
-- node : lambda node 
-- return : pblock 
function process_lambda( node )
    if node.tag ~= "lambda" then
        error "compiler expected lambda node"
    end
    local name = gensym()
    local lambda_body_results = map( process_everything_but_def, node.value )
    local joined_results = fold( pblock_join, pblock_cons( {}, {} ), lambda_body_results )
    local lambda_cblock = cblock_cons( name, joined_results.instr )
    local cblock_list = joined_results.cblock

    table.insert( cblock_list, lambda_cblock )

    -- TODO still need to replace name instance with address
    return pblock_cons( { { instr.push_word, name } }, cblock_list )
end

function process_everything_but_def( node )
    if node.tag == "number" then
        return process_number( node )
    elseif node.tag == "string" then
        return process_string( node )
    elseif node.tag == "word" then
        return process_word( node )
    elseif node.tag == "lambda" then
        return process_lambda( node )
    else
        error "anything but def error"
    end
end

-- node : number node
-- return : pblock 
function process_number( node )
    if node.tag ~= "number" then
        error "compiler expected number node"
    end
    return pblock_cons( { { instr.push_number, node.value } }, {} )
end

-- node : string node
-- return : pbock 
function process_string( node )
    if node.tag ~= "string" then
        error "compiler expected string node"
    end
    return pblock_cons( { { instr.push_string, node.value } }, {} )
end

-- node : word node
-- return : pblock 
function process_word( node )
    if node.tag ~= "word" then
        error "compiler expected word node"
    end
    if special_word( node.value ) then
        return special_word( node.value )
    else
        return pblock_cons( { { instr.call_word, node.value } }, {} ) -- TODO still needs a second pass to replace names with addresses
    end
end

function special_word( name ) 
    if name == "dup" then
        return pblock_cons( { { instr.call_primitive, primitive_key.dup } }, {} )
    elseif name == "drop" then
        return pblock_cons( { { instr.call_primitive, primitive_key.drop } }, {} )
    elseif name == "swap" then
        return pblock_cons( { { instr.call_primitive, primitive_key.swap } }, {} )
    elseif name == "over" then
        return pblock_cons( { { instr.call_primitive, primitive_key.over } }, {} )
    elseif name == "true" then
        return pblock_cons( { { instr.push_bool, true } }, {} )
    elseif name == "false" then
        return pblock_cons( { { instr.push_bool, false } }, {} )
    elseif name == "call" then  -- pop the value on the stack and call it if it's a word
        return pblock_cons( { { instr.call_word_on_stack } }, {} )
    else
        return false
    end
end

