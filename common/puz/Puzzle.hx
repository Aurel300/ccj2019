package puz;

typedef PuzzleD = Puzzle<PuzzleState, Dynamic>;

class Puzzle<T:PuzzleState, U> {
  public function start():T
    throw "not implemented";

  public function tick(s:T):PuzzleTick<T>
    throw "not implemented";

  public function interact(s:T, i:U):PuzzleTick<T>
    throw "not implemented";
}
