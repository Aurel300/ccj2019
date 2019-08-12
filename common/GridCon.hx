enum abstract GridCon(Int) from Int to Int {
  public static function ofDirs(dirs:Array<Dir>):GridCon {
    var res = 0;
    for (d in dirs)
      res |= 1 << (d : Int);
    return (res : GridCon);
  }

  public static function fromSymbol(s:String):GridCon {
    return ofDirs([Dir.fromSymbol(s)]);
  }

  public function toString():String {
    var u = this & 1 != 0;
    var d = this & 4 != 0;
    return (this & 8 != 0 ? "-" : " ") + (u ? (d ? "|" : "'") : (d ? "." : " ")) + (this & 2 != 0 ? "-" : " ");
  }

  @:op(A ^ B)
  public function toggleDir(d:Dir):GridCon {
    return this ^ (1 << (d : Int));
  }

  @:op(A & B)
  public function hasDir(d:Dir):Bool {
    return this & (1 << (d : Int)) != 0;
  }

  public function iterator():Iterator<Dir> {
    return [Dir.Up, Dir.Right, Dir.Down, Dir.Left].filter(hasDir).iterator();
  }

  var None = 0;
  var Up = 1;
  var Right = 2;
  var Down = 4;
  var Left = 8;
}
