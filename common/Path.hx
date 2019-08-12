class Path {
  // TODO: tests for these
  public static function flood(con:Grid<GridCon>, start:GridPos, visit:GridPos->Bool):Bool {
    var queue = [start];
    var visited = con.map(_ -> false);
    while (queue.length > 0) {
      var cur = queue.shift();
      if (visit(cur))
        return true;
      visited[cur] = true;
      for (dir in con[cur]) {
        var off = cur.moveBy(dir);
        if (visited[off])
          continue;
        queue.push(off);
      }
    }
    return false;
  }

  public static function goTo(con:Grid<GridCon>, start:GridPos, goal:GridPos):Null<Array<GridPos>> {
    var queue = [{from: null, to: start, cost: 0}];
    var visited:Grid<{from:GridPos, cost:Int}> = con.map(_ -> null);
    while (queue.length > 0) {
      var cur = queue.shift();
      if (visited[cur.to] != null && visited[cur.to].cost <= cur.cost)
        continue;
      visited[cur.to] = {from: cur.from, cost: cur.cost};
      if (cur.to.equals(goal)) {
        var cur = visited[cur.to];
        var path = [goal];
        while (cur != null) {
          path.push(cur.from);
          cur = visited[cur.from];
        }
        path.reverse();
        return path;
      }
      for (dir in con[cur.to]) {
        var off = cur.to.moveBy(dir);
        queue.push({from: cur.to, to: off, cost: cur.cost + 1});
      }
    }
    return null;
  }
}
