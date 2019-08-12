package puz;

abstract PuzzleParserLex(EReg) from EReg to EReg {
  @:from public static function fromString(s:String):PuzzleParserLex {
    return new EReg(s, "");
  }
}

typedef PuzzleParserLayer<T> = Map<PuzzleParserLex, EReg->PuzzleParserProcess<T>>;

enum PuzzleParserProcess<T> {
  Tile(t:T);
  SkipMatched;
  SkipLine;
  Next;
  Error(msg:String);
}

class PuzzleParser<T, U> {
  final layers:Array<PuzzleParserLayer<T>>;
  final finaliser:Array<Grid<T>>->U;
  final skipEmpty:Bool;

  public function new(layers:Array<PuzzleParserLayer<T>>, finaliser:Array<Grid<T>>->U, ?skipEmpty:Bool = true) {
    this.layers = layers;
    this.finaliser = finaliser;
    this.skipEmpty = skipEmpty;
  }

  public function parse(data:Array<String>, ?posInfos:haxe.PosInfos):U {
    return finaliser([
      for (i in 0...layers.length) {
        if (data[i] == null)
          null;
        else {
          var layerWidth:Null<Int> = null;
          var lines = data[i].split("\n");
          if (skipEmpty)
            lines = lines.filter(l -> l != "");
          var lineNum = 0;
          var parsedTiles = [];
          for (line in lines) {
            lineNum++;
            var pos = 0;
            var tiles = [];
            var skipLine = false;
            while (line.length > 0) {
              var tile = null;
              var anyMatch = false;
              for (re => process in layers[i]) {
                if (!(re:EReg).match(line))
                  continue;
                if ((re:EReg).matchedPos().pos != 0)
                  continue;
                switch (process((re:EReg))) {
                  case Tile(t):
                    tile = t;
                    anyMatch = true;
                  case SkipMatched:
                    anyMatch = true;
                  case SkipLine:
                    anyMatch = true;
                    skipLine = true;
                  case Next:
                  case Error(msg):
                    throw 'parse error in ${posInfos.fileName}:${posInfos.lineNumber}, ${msg} at data:${lineNum}:$pos';
                }
                if (anyMatch) {
                  var len = (re:EReg).matched(0).length;
                  pos += len;
                  line = line.substr(len);
                  break;
                }
              }
              if (!anyMatch)
                throw 'cannot parse data in ${posInfos.fileName}:${posInfos.lineNumber}, unexpected ${line} at data:${lineNum}:$pos';
              if (skipLine)
                break;
              if (tile != null)
                tiles.push(tile);
            }
            if (skipLine || tiles.length == 0)
              continue;
            if (layerWidth != null && layerWidth != tiles.length)
              throw 'line length mismatch in ${posInfos.fileName}:${posInfos.lineNumber}, at data:${lineNum}';
            layerWidth = tiles.length;
            parsedTiles = parsedTiles.concat(tiles);
          }
          if (layerWidth == null)
            null;
          else
            Grid.fromArray(parsedTiles, layerWidth);
        }
      }
    ]);
  }
}
