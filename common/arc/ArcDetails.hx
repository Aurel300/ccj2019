package arc;

class ArcDetails {
  public static function init():Void {
    Story.co.push(co({
      wait(Interact(Hangar, "ship"));
      locked({
        //face("ship");
        "There it is.";
        "Good old 7R45H-can.";
        20;
        "I never understood why people say it looks like garbage.";
      });
      while (true) {
        wait(Interact(Hangar, "ship"));
        "It is not time to return yet.";
      }
    }));
  }
}
