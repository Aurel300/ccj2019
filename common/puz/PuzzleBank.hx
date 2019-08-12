package puz;

class PuzzleBank {
  public static function fromParser<T, U>(parser:PuzzleParser<T, U>, data:Map<String, Array<String>>):Map<String, U> {
    return [for (id => level in data) id => parser.parse(level)];
  }
}
