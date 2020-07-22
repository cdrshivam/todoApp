class ToDoTask{
  String id;
  int isMarked;
  String action;


  ToDoTask(this.id,this.action,this.isMarked);


  @override
  String toString() {
    return 'ToDoTask{id: $id, isMarked: $isMarked, action: $action}';
  }

  Map<String, dynamic> convertToMap() {
    return {'id': id,'action': action, 'isMarked': isMarked};
  }


}