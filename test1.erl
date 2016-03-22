-module(test1).

-export([bench/0]).

-include("test1.hrl").

bench() ->
    {MSec, ok} = timer:tc(fun() -> op1(self()) end),
    ?SECS(MSec) * ?OP_COUNT.

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