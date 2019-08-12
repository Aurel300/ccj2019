enum abstract Dir(Int) from Int to Int {
  public static function fromSymbol(s:String):Dir {
    return (switch (s) {
      case "^": Up;
      case ">": Right;
      case "v": Down;
      case "<": Left;
      case _: throw "!";
    });
  }

  public function opposite():Dir {
    return (switch (this) {
      case Up: Down;
      case Right: Left;
      case Down: Up;
      case Left: Right;
      case _: throw "opposite of invalid direction";
    });
  }

  var Up = 0;
  var Right;
  var Down;
  var Left;
}
