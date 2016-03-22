compile: test1.beam

test1.beam: test1.erl test1.hrl
	erlc test1.erl

m: test1.beam
	escript test1.escript m

s:
	escript test1.escript s

.PHONY: compile

