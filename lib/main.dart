import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collest App Ever',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Collest Main Screen Ever!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Fetching...';
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchServerStatus();
    _fetchUsers();
  }

  Future<void> _fetchServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _status = 'Status: ${data['status']}, Time: ${data['timestamp']}';
        });
      } else {
        setState(() {
          _status = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = data;
        });
      } else {
        setState(() {
          _users = [];
        });
      }
    } catch (e) {
      setState(() {
        _users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(children: [
        Center(child: Text(_status, style: theme.textTheme.headlineSmall)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _fetchServerStatus, child: const Text('Refresh Status')),
              SizedBox(width: 16.0),
              ElevatedButton(onPressed: _fetchUsers, child: const Text('Refresh Users')),
            ],
          ),
        ),
        Container(padding: const EdgeInsets.all(16.0), child: Text('Users:', style: theme.textTheme.headlineSmall)),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _users.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_users[index]['name']),
            subtitle: Text('Role: ${_users[index]['role']}'),
          ),
        ),
      ],),
    );
  }
}
