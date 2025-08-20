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
    _refreshData();
  }

  Future<void> _fetchServerStatus() async {
    try {
      final response = await http.get(        Uri.parse('http://localhost:3000/api/status'),      );

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
      final response = await http.get(        Uri.parse('http://localhost:3000/api/users'),      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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

  Future<void> _refreshData() async {
    await _fetchServerStatus();
    await _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EggeInsets.all(16.0),
            child: Text(
              _status,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Text('Users List', style: theme.textTheme.titleLarge),
          Expanded(
            child: ListView.builer(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('Role: ${user['role'}}',),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Refresh Data'),
            ),
          ),
        ],
      ),    );  }
}
