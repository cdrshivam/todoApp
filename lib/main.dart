import 'package:flutter/material.dart';

import './screens/todoList.dart';

void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO_sqlite',
        home: TodoList(),
      )
  );
}