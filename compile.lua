

require 'seq'
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
function process_lambda( lamb )

end

function process_list_of_things_not_def()
end



-- TODO I'm going to need a list of special words one way or the other (dup, etc)
-- so I might as well add true and false there as well 
function process_special_word()
end

function blah( ast )
    if ast.tag == "word" then 

    elseif ast.tag == "string" then 

    elseif ast.tag == "number" then

    elseif ast.tag == "lambda" then

    end
end
