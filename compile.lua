

-- module( ..., package.seeall )

function blah( ast )
    if ast.tag == "word" then

    elseif ast.tag == "string" then

    elseif ast.tag == "number" then

    elseif ast.tag == "lambda" then

    elseif ast.tag == "top" then

    elseif ast.tag == "definition" then

    elseif ast.tag == "comment" then

-- todo add boolean
    end
end
