all: bin/game.js

bin/game.js: $(shell find game -type f -name *.hx)
	haxe make.hxml

test:
	haxe test.hxml

.PHONY: all test
