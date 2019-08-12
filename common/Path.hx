class Path {
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
}
