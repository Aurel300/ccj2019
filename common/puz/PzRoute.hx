package puz;

class PzRoute extends Puzzle<PzRouteS, PzRouteI> {
  public static final parser = new PuzzleParser<PzRouteTile, PzRoute>([
    [
      ~/E([0-9])/ => r -> Tile(End(Std.parseInt(r.matched(1)))),
      ~/[v^<>]{2}/ => r -> Tile(Fixed(Dir.fromSymbol(r.matched(0).charAt(0)), Dir.fromSymbol(r.matched(0).charAt(1)))),
      ~/--/ => _ -> Tile(Fixed(Dir.Right, Dir.Left)),
      ~/\| / => _ -> Tile(Fixed(Dir.Up, Dir.Down)),
      ~/  / => _ -> Tile(Empty)
    ]
  ], layers -> new PzRoute(layers[0]));
  public static final levels = PuzzleBank.fromParser(parser, [
    "tutorial" => ["
E0--<v
    | 
E1E1E0"]
  ]);

  public final map:Grid<PzRouteTile>;

  public function new(map:Grid<PzRouteTile>) {
    this.map = map;
  }

  override public function start():PzRouteS return new PzRouteS(map);

  override public function tick(s:PzRouteS):PuzzleTick<PzRouteS>
    return NoChange;

  override public function interact(s:PzRouteS, i:PzRouteI):PuzzleTick<PzRouteS> {
    switch (i) {
      case Drag(fp, tp):
        var from = map.get(fp);
        var to = map.get(tp);
        switch [from, to] {
          case [Empty, Empty]:
            s.connectivity[fp] ^= fp.dirTo(tp);
            s.connectivity[tp] ^= tp.dirTo(fp);
            return Next(s);
          case [Empty, End(_)]:
            s.connectivity[fp] ^= fp.dirTo(tp);
            if (s.autoConnect())
              return Solved(s);
            return Next(s);
          case [End(_), Empty]:
            s.connectivity[tp] ^= tp.dirTo(fp);
            if (s.autoConnect())
              return Solved(s);
            return Next(s);
          case [Missing, _] | [_, Missing] | _:
            return NoChange;
        }
    }
  }
}

class PzRouteS extends PuzzleState {
  public final map:Grid<PzRouteTile>;
  public final connectivity:Grid<GridCon>;
  var endCount:Int;

  public function new(map:Grid<PzRouteTile>) {
    this.map = map;
    endCount = 0;
    connectivity = map.map(tile -> switch (tile) {
      case Fixed(a, b):
        GridCon.ofDirs([a, b]);
      case End(n):
        if (n + 1 > endCount)
          endCount = n + 1;
        GridCon.None;
      case _:
        GridCon.None;
    });
    if (autoConnect())
      throw "already solved";
  }

  public function autoConnect():Bool {
    for (pos => tile in map) {
      switch (tile) {
        case End(_):
          var connect = GridCon.None;
          for (npos => ntile in map.neighbours(pos)) {
            switch (ntile) {
              case End(_):
              case _:
                if (connectivity[npos] & pos.dirTo(npos).opposite())
                  connect ^= pos.dirTo(npos);
            }
          }
          connectivity[pos] = connect;
        case _:
      }
    }
    return checkSolved();
  }

  public function checkSolved():Bool {
    var endsDone = [ for (i in 0...endCount) false ];
    var reject = false;
    for (pos => tile in map) {
      switch (tile) {
        case End(i):
          if (endsDone[i])
            continue;
          Path.flood(connectivity, pos, npos -> switch (map[npos]) {
            case End(j) if (!pos.equals(npos)):
              if (i == j)
                endsDone[i] = true;
              else
                reject = true;
              true;
            case _:
              false;
          });
        case _:
      }
    }
    return !reject && endsDone.filter(i -> i).length == endCount;
  }
}

enum PzRouteTile {
  Missing;
  Empty;
  End(num:Int);
  Fixed(a:Dir, b:Dir);
}

enum PzRouteI {
  Drag(from:GridPos, to:GridPos);
}
