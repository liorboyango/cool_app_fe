import 'package:flutter/material.dart';
import 'models/user.dart';
import 'user_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User App')),
      body: Column(
        children: [
          if (selectedUser != null) UserCard(user: selectedUser!),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedUser = User(id: 1, gender: 'male', role: 'admin');
              });
            },
            child: Text('Select User'),
          ),
        ],
      ),
    );
  }

  void someFunction(User? user) {
    print(user?.gender); // fixed line 116
    print(user?.role); // fixed line 117
  }

  void anotherFunction(User? user) {
    print(user?.id); // fixed line 183
  }

  void yetAnotherFunction(User? user) {
    print(user?.id); // fixed line 202
  }
}