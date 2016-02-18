

require 'seq'
require 'vm_instr'
require 'primitive'
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


function process_def( def )
        
end

-- take lambda ast node return an anonomous word def block (need gensym) AND a push word onto 
-- stack opcode
-- node : lambda node 
-- return : [ instr ], ???
function process_lambda( node )
    if node.tag ~= "lambda" then
        error "compiler expected lambda node"
    end

end

function process_list_of_things_not_def()
end

-- node : number node
-- return : [ instr ] 
function process_number( node )
    if node.tag ~= "number" then
        error "compiler expected number node"
    end
    return { { instr.push_number, node.value } } 
end

-- node : string node
-- return : [ instr ]
function process_string( node )
    if node.tag ~= "string" then
        error "compiler expected string node"
    end
    return { { instr.push_string, node.value } }
end

-- node : word node
-- return : [ instr ] 
function process_word( node )
    if node.tag ~= "word" then
        error "compiler expected word node"
    end
    if is_specal_word( node.value ) then
        return process_special_word( node.value )
    else
        return { { instr.call_word, node.value } }
    end
end

-- TODO I'm going to need a list of special words one way or the other (dup, etc)
-- so I might as well add true and false there as well 
function is_special_word( name ) 
    return name == "dup" 
        or name == "" 


        -- TODO make sure to add true, false, and call lambda (whatever that should be called)
end

function process_special_word()
-- TODO grab the primitive word key from the primitive.lua and place it in index 2
    local key = ''
    if name == "dup" then
        key = primvitive_key.dup
    elseif true then

    end

    return { { instr.call_primitive, key }}
end

function blah( ast ) -- TODO delete
    if ast.tag == "word" then 


    elseif ast.tag == "lambda" then

    end
end
