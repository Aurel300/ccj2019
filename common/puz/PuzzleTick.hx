package puz;

enum PuzzleTick<T:PuzzleState> {
  NoChange;
  Next(s:T);
  Lost(s:T);
  Solved(s:T);
}
