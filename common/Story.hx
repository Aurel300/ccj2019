import arc.*;

class Story {
  public static var tickCounter(default, null):Int = 0;
  public static var co:Array<pecan.CoFactory<Void, Void>> = [];
  public static var eventHandlers:Array<StoryEvent->Void> = [];
  public static var tickHandlers:Map<Int, ()->Void> = [];

  public static function init() {
    ArcDetails.init();
    for (c in co)
      c.run();
  }

  public static function event(e:StoryEvent):Void {
    for (handler in eventHandlers)
      handler(e);
  }

  public static function once(matcher:StoryEvent->Bool, f:() -> Void):Void {
    eventHandlers.push(function wrapped(e:StoryEvent) {
      if (matcher(e)) {
        eventHandlers.remove(wrapped);
        f();
      }
    });
  }

  public static function delay(ticks:Int, f:() -> Void):Void {
    tickHandlers[tickCounter + ticks] = f;
  }

  public static function tick():Void {
    for (tick => f in tickHandlers) {
      if (tickCounter < tick)
        continue;
      f();
      tickHandlers.remove(tick);
    }
  }

  // TODO: move these elsewhere
  public static function say(msg:String, then:()->Void):Void {
    trace(msg);
    then();
  }

  public static function lock():Void {}

  public static function unlock():Void {}
}
