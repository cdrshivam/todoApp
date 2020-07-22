import 'package:sqflite/sqflite.dart';

import '../Model/action.dart';

class Db{
  static int get _version=>1;
  static Database _db;
  static init() async{
    try{
      //define the path to the data base from your device
      String _path=await getDatabasesPath() +'todo';
      //open the table in which you want to enter records
      _db = await openDatabase(_path,
        version: _version,
        onCreate: createTodoTable,
      );



    }catch(e)
    {
      print('Eception caught inside init state is $e');
    }
  }

  static void createTodoTable(Database db, int version) async{
    await db.execute('CREATE TABLE todo(id STRING, action STRING, isMarked BOOL)');
  }

  static Future<List<Map<String,dynamic>>> query() async{
    var todoList=_db.query('todo');
    return todoList;
  }

  static Future<int> add(ToDoTask action) async{
    int ans=await _db.insert('todo',
      action.convertToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return ans;
  }

  static Future<int> deleteToDo(String table,String id) async{
    int ans= await _db.delete(table,whereArgs: [id],where: 'id=?');
    return ans;
  }

  static Future<int> deleteAll(String table) async{
    int ans = await _db.delete(table);
    return ans;
  }

  static Future<int> update(ToDoTask action) async{
    int ans=await _db.update('todo',
      action.convertToMap(),
      where: 'id = ?',
      whereArgs: [action.id],
    );
    return ans;
  }


}