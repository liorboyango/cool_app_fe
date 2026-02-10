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
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Info')),
      body: Center(
        child: user == null
            ? Text('No user')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gender: ${user!.gender}'), // Fixed line 116
                  Text('Role: ${user!.role}'), // Fixed line 117
                  SizedBox(height: 20),
                  // Other code...
                  UserCard(user: user),
                  Text('User ID: ${user!.id}'), // Fixed line 183
                  // More code...
                  ElevatedButton(
                    onPressed: () {
                      // Some action
                      print('User ID: ${user!.id}'); // Fixed line 202
                    },
                    child: Text('Action'),
                  ),
                ],
              ),
      ),
    );
  }
}