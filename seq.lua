

function id( i )
    return i
end

function const( k )
    return function( x ) return k end
end

function map( f, l )
    local t = {}
    for _, llet in ipairs( l ) do
        table.insert( t, f( llet ) )
    end
    return t
end

function filter( p, l )
    local t = {}
    for _, llet in ipairs( l ) do
        if p( llet ) then
            table.insert( t, llet )
        end
    end
    return t
end

function fold( c, i, l )
    assert( c ~= nil, "the collector function cannot be nil" )
    assert( i ~= nil, "the initial item cannot be nil" )
    assert( l ~= nil, "the list cannot be nil" )

    local sum = i

    for _, llet in ipairs( l ) do
        sum = c( sum, llet )
    end

    return sum
end

function sum( c, l )
    return fold( function ( a, b ) return a + b end, 0, map( c, l ) )
end

function max( c, l )
    local o = map( c, l )
    local m = o[1]
    for _, v in ipairs( o ) do
        if v > m then
            m = v
        end
    end
    return m
end
