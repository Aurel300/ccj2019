package puz;

typedef PuzzleD = Puzzle<Dynamic, Dynamic>;

class Puzzle<T:PuzzleState, U> {
  public var type:String;
  public var id:String;

  public function new(type:String, id:String) {
    this.type = type;
    this.id = id;
  }

  public function start():T
    throw "not implemented";

  public function tick(s:T):PuzzleTick<T>
    throw "not implemented";

  public function interact(s:T, i:U):PuzzleTick<T>
    throw "not implemented";
}
