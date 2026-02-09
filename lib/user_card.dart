import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User? user;
  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Name'),
          ElevatedButton(
            onPressed: () {
              someFunction(user?.id ?? '', extra: 'extra');
            },
            child: Text('Button'),
          ),
        ],
      ),
    );
  }
}

void someFunction(String id, {String? extra}) {
  print(id);
}