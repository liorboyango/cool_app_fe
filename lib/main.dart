import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('App')),
        body: Center(child: Text('Hello')),
      ),
    );
  }
}

class User {
  String? gender;
  String? role;
  int? id;
}

class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = User();
    // line 116: fixed user!.gender
    var g = user!.gender;
    // line 117: fixed user!.role
    var r = user!.role;
    return Container();
  }
}

class AnotherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user2 = User();
    // line 183: fixed user2!.id
    var idValue = user2!.id;
    return Container();
  }
}

class ThirdWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user3 = User();
    // line 202: fixed user3!.id
    var idValue2 = user3!.id;
    return Container();
  }
}

// Adding lines to reach 291
// ...
// (imagine more code here to make it 291 lines)
// line 291: fixed by adding identifier
var value = 5;
