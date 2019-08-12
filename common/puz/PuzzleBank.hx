package puz;

import puz.Puzzle.PuzzleD;

class PuzzleBank {
  public static function fromParser<T, U:PuzzleD>(parser:PuzzleParser<T, U>, data:Map<String, Array<String>>):Map<String, U> {
    return [for (id => level in data) id => {
      var puzzle = parser.parse(level);
      puzzle.id = id;
      puzzle;
    }];
  }
}
