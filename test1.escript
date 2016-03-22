#! /usr/bin/env escript

-include("test1.hrl").

main([]) ->
    io:format("Usage:~n"),
    io:format("  bench script: ./test1.escript s)~n"),
    io:format("  bench module: ./test1.escript m)~n");

main([M]) ->
    R = case M of
        "s" -> bench();
        "m" -> test1:bench()
    end,
    io:format("Operations per second: ~f~n", [R]).

bench() ->
    {MSec, ok} = timer:tc(fun() -> op1(self()) end),
    ?SECS(MSec * ?OP_COUNT).

op1(Parent) ->
    do(Parent, ?OP_COUNT),
    barrier_loop(?OP_COUNT).

do(_, 0) ->
    ok;

do(Parent, N) ->
    Parent ! hit,
    do(Parent, N - 1).

barrier_loop(0) ->
    ok;

barrier_loop(N) ->
    receive
        hit ->
            barrier_loop(N - 1)
    end.