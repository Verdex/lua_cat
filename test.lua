
require 'util'
require 'compile'
require 'parse'
require 'vm'

t = parse_top_level( make_stream [[ 
    : main 
        2 neap ;

    : != 
        = [ false ] [ true ] if ;

    : loop
        dup call loop ;

    : neap 
        dup 0 != [ "again" print - 1 neap ] [ "done" ] if ;

    : blarg 
        4 5 ;

    : ikky 
        = ;

    : jabber 
        [ "equal" print ] [ "not equal" print ] if ;

    : wocky
        call ;

]] )

assert( t ~= nil )

r = compile( t )

run( r )

