package test;

import puz.*;

class TestPuzzles extends Test {
  function seqSolve<T:puz.PuzzleState, U>(p:Puzzle<T, U>, interacts:Array<U>):Void {
    var state:T = p.start();
    var solved = false;
    for (interact in interacts) {
      if (solved)
        assert("interacts after solved");
      var tick = interact == null ? p.tick(state) : p.interact(state, interact);
      switch (tick) {
        case NoChange:
        case Next(s):
          state = s;
        case Lost(_):
          assert("should not have lost");
        case Solved(s):
          state = s;
          solved = true;
      }
    }
    t(solved);
  }

  function testRoute() {
    seqSolve(PzRoute.levels["tutorial"], [
      Drag({x: 0, y: 2}, {x: 0, y: 1}),
      Drag({x: 0, y: 1}, {x: 1, y: 1}),
      Drag({x: 1, y: 1}, {x: 1, y: 2})
    ]);
    seqSolve(PzRoute.levels["tutorial"], [
      Drag({x: 1, y: 2}, {x: 1, y: 1}),
      Drag({x: 0, y: 1}, {x: 1, y: 1}),
      Drag({x: 0, y: 1}, {x: 1, y: 1}),
      Drag({x: 0, y: 1}, {x: 1, y: 1}),
      Drag({x: 0, y: 2}, {x: 0, y: 1})
    ]);
  }
}
