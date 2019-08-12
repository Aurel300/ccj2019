package test;

import puz.*;

class TestPuzzles extends Test {
  function seq<T:puz.PuzzleState, U>(p:Puzzle<T, U>, interacts:Array<U>, ?posInfos:haxe.PosInfos):{state:T, solved:Bool, lost:Bool} {
    var state:T = p.start();
    var solved = false;
    var lost = false;
    for (interact in interacts) {
      if (solved || lost)
        assert("interacts after done", posInfos);
      var tick = interact == null ? p.tick(state) : p.interact(state, interact);
      switch (tick) {
        case NoChange:
        case Next(s):
          state = s;
        case Lost(s):
          state = s;
          lost = true;
        case Solved(s):
          state = s;
          solved = true;
      }
    }
    return {state: state, solved: solved, lost: lost};
  }

  function seqSolve<T:puz.PuzzleState, U>(p:Puzzle<T, U>, interacts:Array<U>, ?posInfos:haxe.PosInfos):Void {
    var res = seq(p, interacts, posInfos);
    f(res.lost, posInfos);
    t(res.solved, posInfos);
  }

  function seqNC<T:puz.PuzzleState, U>(p:Puzzle<T, U>, interacts:Array<U>, ?posInfos:haxe.PosInfos):Void {
    var res = seq(p, interacts, posInfos);
    f(res.lost, posInfos);
    f(res.solved, posInfos);
  }

  function testRoute() {
    var lp:Int = 0;
    function p(?n:Int):GridPos {
      if (n == null)
        return {x: Std.int(lp / 100), y: lp % 100};
      lp = n;
      return {x: Std.int(n / 100), y: n % 100};
    }
    // @formatter:off
    seqSolve(PzRoute.levels["tutorial"], [
      Drag(p(  2), p(  1)),
      Drag(p(   ), p(101)),
      Drag(p(   ), p(102)),
    ]);
    seqSolve(PzRoute.levels["tutorial"], [
      Drag(p(102), p(101)),
      Drag(p(  1), p(101)),
      Drag(p(  1), p(101)),
      Drag(p(  1), p(101)),
      Drag(p(  2), p(  1)),
    ]);
    seqSolve(PzRoute.levels["yinyang"], [
      Drag(p(  0), p(  1)),
      Drag(p(   ), p(  2)),
      Drag(p(   ), p(  3)),
      Drag(p(   ), p(103)),
      Drag(p(   ), p(203)),
      Drag(p(   ), p(202)),
      Drag(p(   ), p(201)),

      Drag(p(303), p(302)),
      Drag(p(   ), p(301)),
      Drag(p(   ), p(300)),
      Drag(p(   ), p(200)),
      Drag(p(   ), p(100)),
      Drag(p(   ), p(101)),
      Drag(p(   ), p(102)),
    ]);
    seqNC(PzRoute.levels["yinyang"], [
      Drag(p(  0), p(100)),
      Drag(p(   ), p(200)),
      Drag(p(   ), p(201)),

      Drag(p(303), p(203)),
      Drag(p(   ), p(103)),
      Drag(p(   ), p(102)),
    ]);
    seqSolve(PzRoute.levels["snail"], [
      Drag(p(  4), p(  3)),
      Drag(p(   ), p(  2)),
      Drag(p(   ), p(  1)),
      Drag(p(   ), p(  0)),
      Drag(p(   ), p(100)),
      Drag(p(   ), p(200)),
      Drag(p(   ), p(300)),
      Drag(p(   ), p(400)),
      Drag(p(   ), p(500)),
      Drag(p(   ), p(501)),
      Drag(p(   ), p(502)),
      Drag(p(   ), p(503)),
      Drag(p(   ), p(504)),
      Drag(p(   ), p(404)),
      Drag(p(   ), p(304)),
      Drag(p(   ), p(204)),
      Drag(p(   ), p(203)),

      Drag(p(104), p(103)),
      Drag(p(   ), p(102)),
      Drag(p(   ), p(202)),
      Drag(p(   ), p(302)),
      Drag(p(   ), p(303)),

      Drag(p(403), p(402)),
      Drag(p(   ), p(402)),
      Drag(p(   ), p(401)),
      Drag(p(   ), p(301)),
      Drag(p(   ), p(201)),
      Drag(p(   ), p(101)),
    ]);
    // @formatter:on
  }
}
