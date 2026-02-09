import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = getUser();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(user?.gender ?? 'unknown'),
            Text(user?.role ?? 'unknown'),
            ElevatedButton(
              onPressed: () {
                print(user?.id);
              },
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }

  void someMethod() {
    User? user = getUser();
    print(user?.id);
  }
}

class User {
  String gender;
  String role;
  String id;
  User(this.gender, this.role, this.id);
}

User? getUser() {
  return User('male', 'admin', '1');
}