import haxe.macro.Expr;

using haxe.macro.ExprTools;

class Cro {
  public static function co(block:Expr, ?tin:Expr, ?tout:Expr):Expr {
    function walk(e:Expr):Expr {
      return (switch (e.expr) {
        case ECall({expr: EConst(CIdent("wait"))}, [arg]):
          macro suspend((self, wakeup) -> Story.once(e -> e.match($arg), wakeup));
        case ECall({expr: EConst(CIdent("locked"))}, [block]):
          macro $b{[
            macro Story.lock(),
            walk(block),
            macro Story.unlock()
          ]};
        case EBlock(bs):
          {
            expr: EBlock([
              for (b in bs)
                switch (b.expr) {
                  case EConst(CString(msg)):
                    macro suspend((self, wakeup) -> Story.say($b, wakeup));
                  case EConst(CInt(ticks)):
                    macro suspend((self, wakeup) -> Story.delay($b, wakeup));
                  case _:
                    walk(b);
                }
            ]),
            pos: e.pos
          };
        case _:
          e.map(walk);
      });
    }
    block = walk(block);
    // trace(new haxe.macro.Printer().printExpr(block));
    return pecan.Co.co(block, tin, tout);
  }
}
