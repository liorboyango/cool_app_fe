import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;
  Item? item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      body: Column(
        children: [
          Text(user?.gender ?? 'N/A'),
          Text(user?.role ?? 'N/A'),
          // Additional lines to approximate line numbers
          // ...
          // Assuming line 183 is here
          Text(item?.id ?? 'N/A'),
          // More lines
          // ...
          // Assuming line 202 is here
          Text(user?.id ?? 'N/A'),
        ],
      ),
    );
  }
}

class User {
  String? gender;
  String? role;
  String? id;
}

class Item {
  String? id;
}