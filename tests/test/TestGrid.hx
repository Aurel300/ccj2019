package test;

class TestGrid extends Test {
  function testGrid() {
    var a = Grid.fromArray([1, 2, 3, 4, 5, 6, 7, 8, 9], 3);
    gridEq(a, [1, 2, 3, 4, 5, 6, 7, 8, 9], 3);
    eq(a[0][0], 1);
    eq(a[1][1], 5);
    eq(a[2][0], 3);
    eq(a[0][2], 7);
    eq(a[2][2], 9);
    eq(a[{x: 0, y: 0}], 1);
    eq(a[{x: 1, y: 1}], 5);
    eq(a[{x: 2, y: 0}], 3);
    eq(a[{x: 0, y: 2}], 7);
    eq(a[{x: 2, y: 2}], 9);
    var a = Grid.fromArray([1, 2, 3, 4, 5, 6, 7, 8], 4);
    eq(a[0][0], 1);
    eq(a[3][0], 4);
    eq(a[0][1], 5);
    eq(a[3][1], 8);
    var a = a.map(n -> n * 2);
    eq(a[0][0], 1 * 2);
    eq(a[3][0], 4 * 2);
    eq(a[0][1], 5 * 2);
    eq(a[3][1], 8 * 2);
  }

  function testDir() {
    eq(Dir.Up.opposite(), Dir.Down);
  }

  function testCon() {
    var c = GridCon.None;
    c ^= Dir.Left;
    f(c & Dir.Up);
    f(c & Dir.Right);
    f(c & Dir.Down);
    t(c & Dir.Left);
    c ^= Dir.Right;
    f(c & Dir.Up);
    t(c & Dir.Right);
    f(c & Dir.Down);
    t(c & Dir.Left);
  }
}
