import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Model/operation.dart';
import '../Model/action.dart';
import '../utils/db.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  var uuid = new Uuid();

  var url='https://apprecs.org/gp/images/app-icons/300/8a/io.tinbits.memorigi.jpg';

   TextEditingController _task=new TextEditingController();
  TextEditingController _updatedTask=new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Db.init();
  }

  _refresh(){
    print('refresh state is called');

    setState(() {
      TodoList();
    });
  }

   _add(){
     print('enter in add function');
     ToDoTask tc = ToDoTask(uuid.v4(),_task.text, 0);
     print('tc is created : tc: ${tc.toString()}');
     Operation.addToDo(tc).then((message){
       print('add status : $message');
     }).catchError((err){
       print('error occured : $err');
     });
   }


  _showDialog(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(

          title: Text('Add task'),
          content: TextField(
              controller: _task,
              decoration: InputDecoration(
                hintText: 'Enter your task',
              ),
            ),

          actions: <Widget>[
            RaisedButton(
                color: Colors.lightBlueAccent,
                child: Text('Add'),
                onPressed: (){
                  _refresh();
                  _add();
                  print('add task button is pressed');
                  Navigator.of(context).pop();
                }
            ),
            SizedBox(width: 5,),
            RaisedButton(
              color: Colors.lightBlueAccent,
              child: Text('Cancel'),
                onPressed: (){
                  print('cancel button is pressed');
                  Navigator.of(context).pop();
                }
            ),
            SizedBox(width: 15,),
          ],
        );
      }

    );
  }


  _updateDialog(String id){
    print('update task called');
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(

            title: Text('Update task'),
            content: TextField(
                  controller: _updatedTask,
                  decoration: InputDecoration(
                    hintText: 'Enter your task',
                  ),
                ),
            actions: <Widget>[
              RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Update'),
                  onPressed: (){
                    _refresh();
                    _updateTask(id,_updatedTask.text,0);
                    print('update task button is pressed');
                    Navigator.of(context).pop();
                  }
              ),
              SizedBox(width: 5,),
              RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Cancel'),
                  onPressed: (){
                    print('cancel button is pressed');
                    Navigator.of(context).pop();
                  }
              ),
              SizedBox(width: 15,),
            ],
          );
        }

    );
  }


  _deleteAll() async{
    String status = await Operation.deleteAll();
    print(' table deleted status: $status');
  }

  _deleteTask(String id) async{
    String status = await Operation.deleteToDo(id);
    print(' task deleted status: $status');
  }


  _updateTask(String id,String task,int markedStatus) async{
    print('enter in add function');
    ToDoTask tc = ToDoTask(id,task, markedStatus);
    print('tc is created : tc: ${tc.toString()}');
    Operation.updateToDo(tc).then((message){
      print('add status : $message');
    }).catchError((err){
      print('error occured : $err');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text('TODO List',
          softWrap: true,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.white, size: 18),
              onPressed: (){
                _refresh();
                _deleteAll();
              },
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
          elevation: 10,
          tooltip: 'Add your task here',
          onPressed: (){
            _showDialog();
          }
      ),

      body: FutureBuilder(
        future: Operation.getToDo(),
          builder: (context,asyncSnapShot){

            if(asyncSnapShot.data==null){
              return Center(
                  child: CircularProgressIndicator(),
              );
            }
            else if(asyncSnapShot.hasData==true){
              return ListView.builder(
                itemBuilder: (context,index){

                  if(asyncSnapShot.data.length<1){
                    return Container(
                      height: 200,
                      width: 200,
                      child: Image(image: NetworkImage(url)),
                    );
                  }
                  else{
                    return ListTile(
                      onTap: (){
                        _updateDialog(asyncSnapShot.data[index].id);
                        print('on tap is pressed of task ${index+1}');
                      },
                      title: Text(asyncSnapShot.data[index].action,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      leading: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.indigo,
                          value: (asyncSnapShot.data[index].isMarked==0)?false:true,
                          onChanged: (bool value){
                            setState(() {
                              asyncSnapShot.data[index].isMarked=(value==false)?0:1;
                              _updateTask(asyncSnapShot.data[index].id, asyncSnapShot.data[index].action, asyncSnapShot.data[index].isMarked);

                            });
                          }
                      ),
                      trailing: IconButton(
                          color: Colors.black54,
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            _deleteTask(asyncSnapShot.data[index].id);
                            _refresh();
                          }
                      ),
                    );
                  }
                },
                itemCount: asyncSnapShot.data.length,
              );
            }
            else{
              return Center(
                child: LinearProgressIndicator(),
              );
            }
          },
       //future: Operation.getToDo(),
      ),
    );
  }
}
