

require 'seq'
-- input is an ast and the output is ... a list of instructions for the vm

-- ast -> instruction list
function compile( ast )

    if ast.tag ~= "top" then
        error "compile needs to be passed an AST with a top level node"
    end

    -- ast.value is a list of comments and definitions
    -- get rid of comments
    local defs = filter( function( a ) return a.tag ~= "comment" end, ast.value )

    for _, v in ipairs( defs ) do
        if v.tag ~= "definition" then
            error "compiler top level contains non definition or non comment node"
        end
    end

end

function blah( ast )
    if ast.tag == "word" then 

    elseif ast.tag == "string" then 

    elseif ast.tag == "number" then

    elseif ast.tag == "lambda" then -- list of things that aren't definitions i think

    elseif ast.tag == "top" then -- has like a list of top level stuff (comments and definitions?)

    elseif ast.tag == "definition" then -- name and then list of things that aren't definitions i think

    elseif ast.tag == "comment" then

    elseif ast.tag == "boolean" then

    end
end
