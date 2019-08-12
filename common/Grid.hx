typedef GridData<T> = {w:Int, h:Int, d:Array<T>};

abstract Grid<T>(GridData<T>) from GridData<T> to GridData<T> {
  public static function fromArray<T>(d:Array<T>, w:Int):Grid<T> {
    if (d.length % w != 0)
      throw "invalid grid (len % w != 0)";
    return {w: w, h: Std.int(d.length / w), d: d};
  }

  public inline function raw():GridData<T> return this;

  @:arrayAccess
  public function getColumn(x:Int):GridColumn<T> {
    return {x: x, g: this};
  }

  @:arrayAccess
  public function get(p:GridPos):T {
    return this.d[p.x + this.w * p.y];
  }

  @:arrayAccess
  public function set(p:GridPos, to:T):T {
    return this.d[p.x + this.w * p.y] = to;
  }

  public function keyValueIterator():KeyValueIterator<GridPos, T>
    return [
      for (y in 0...this.h)
        for (x in 0...this.w)
          {x: x, y: y}
            => this.d[x + this.w * y]
    ].keyValueIterator();

  public function iterator():Iterator<T> return [for (y in 0...this.h) for (x in 0...this.w) this.d[x + this.w * y]].iterator();

  public function map<U>(f:T->U):Grid<U> {
    return fromArray(this.d.map(f), this.w);
  }

  public function contains(p:GridPos):Bool {
    return p.x >= 0 && p.x < this.w && p.y >= 0 && p.y < this.h;
  }

  public function neighbours(of:GridPos):KeyValueIterator<GridPos, T> {
    return [
      for (pos in [
        {x: of.x, y: of.y - 1},
        {x: of.x + 1, y: of.y},
        {x: of.x, y: of.y + 1},
        {x: of.x - 1, y: of.y}
      ].filter(contains))
        pos => get(pos)
    ].keyValueIterator();
  }

  public function toString():String {
    function pad(s:String) {
      while (s.length < 3)
        s += " ";
      return s;
    }
    return "\n" + [
      for (y in 0...this.h) [for (x in 0...this.w) pad('${this.d[x + this.w * y]}')].join("")
    ].join("\n");
  }
}

typedef GridColumnData<T> = {x:Int, g:Grid<T>};

abstract GridColumn<T>(GridColumnData<T>) from GridColumnData<T> {
  @:arrayAccess
  public inline function getElement(y:Int):T {
    return this.g.raw().d[this.x + this.g.raw().w * y];
  }
}
