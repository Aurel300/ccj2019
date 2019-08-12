typedef GridPos = {x:Int, y:Int};

class GridPosTools {
  public static function isAdjacent(a:GridPos, b:GridPos):Bool {
    return (a.x == b.x && (a.y == b.y + 1 || a.y == b.y - 1)) || (a.y == b.y && (a.x == b.x + 1 || a.x == b.x - 1));
  }

  public static function dirTo(a:GridPos, b:GridPos):Null<Dir> {
    if (a.x == b.x) {
      if (a.y == b.y + 1) return Up;
      if (a.y == b.y - 1) return Down;
    }
    if (a.y == b.y) {
      if (a.x == b.x + 1) return Left;
      if (a.x == b.x - 1) return Right;
    }
    return null;
  }

  public static function moveBy(origin:GridPos, dir:Dir, ?steps:Int = 1):GridPos {
    return (switch (dir) {
      case Up: {x: origin.x, y: origin.y - steps};
      case Right: {x: origin.x + steps, y: origin.y};
      case Down: {x: origin.x, y: origin.y + steps};
      case Left: {x: origin.x - steps, y: origin.y};
      case _: throw "!";
    });
  }

  public static function equals(a:GridPos, b:GridPos):Bool {
    return a.x == b.x && a.y == b.y;
  }
}
