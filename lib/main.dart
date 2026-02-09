import 'package:flutter/material.dart';
import 'user_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: UserCard(),
      ),
    );
  }
}

class User {
  String gender;
  String role;
  int id;
  User(this.gender, this.role, this.id);
}

void someFunction() {
  User? user = User('male', 'admin', 1);
  // line 116
  String gender = user!.gender;
  // 117
  String role = user!.role;
  // more code
  User? u = User('female', 'user', 2);
  // 183
  int id = u!.id;
  // 202
  int id2 = u!.id;
}