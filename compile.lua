

-- input is an ast and the output is ... a list of instructions for the vm

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
