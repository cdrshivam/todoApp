import './action.dart';
import '../utils/db.dart';


class Operation{
  static Future<List> getToDo() async{
    List<ToDoTask> actions=[];
    List<Map<String,dynamic>> list=await Db.query();
    print('all records are : $list');

    list.forEach((map){
      actions.add(ToDoTask(map['id'],map['action'],map['isMarked']));
    });
    print('records list are : $actions');
    return actions;
  }

  static Future<String> addToDo(ToDoTask action) async{
    print('in add function : $action');
    int ans= await Db.add(action);
    if(ans>0){
      return 'Todo added';
    }
    else{
      return 'Todo not added';
    }
  }

  static Future<String> deleteToDo(String id) async{
    int ans= await Db.deleteToDo('todo',id);
    if(ans>0){
      return 'Todo deleted';
    }
    else{
      return 'Todo not deleted';
    }
  }

  static Future<String> deleteAll() async{
    int ans=await Db.deleteAll('todo');
    if(ans>0){
      return 'Todo all deleted';
    }
    else{
      return 'Todo all not deleted';
    }
  }

  static Future<String> updateToDo(ToDoTask action) async{
    int ans= await Db.update(action);
    if(ans>0){
      return 'Todo updated';
    }
    else{
      return 'Todo not updated';
    }
  }


}