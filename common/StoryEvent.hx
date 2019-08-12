enum StoryEvent {
  Enter(_:RoomName);
  Interact(_:RoomName, obj:String);
  MoveTo(_:RoomName, pos:GridPos);
  Start(type:String, id:String);
  Solve(type:String, id:String);
  Lose(type:String, id:String);
}
