package test;

import puz.PuzzleParser;

class TestParser extends Test {
  function testParser() {
    gridEq(new PuzzleParser<Int, Grid<Int>>([
      [
        "([0-9])" => re -> Tile(Std.parseInt(re.matched(1)))
      ]
    ], layers -> layers[0]).parse([
      "951\n357"
    ]), [9, 5, 1, 3, 5, 7], 3);
    gridEq(new PuzzleParser<Int, Grid<Int>>([
      [
        "([0-9]{2})" => re -> Tile(Std.parseInt(re.matched(1)))
      ]
    ], layers -> layers[0]).parse([
      "905010\n305070"
    ]), [90, 50, 10, 30, 50, 70], 3);
  }
}
