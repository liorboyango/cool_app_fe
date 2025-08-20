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
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final statusResponse = await http.get(
        Uri.parse('http://localhost:3000/api/status'),
      );
      if (statusResponse.statusCode == 200) {
        final data = json.decode(statusResponse.body);
        setState(() {
          _status = 'Status: ${data['status']}, Time: ${data['timestamp']}';
        });
      } else {
        setState(() {
          _status = 'Server error: ${statusResponse.statusCode}';
        });
      }
      final usersResponse = await http.get(
        Uri.parse('http://localhost:3000/api/users'),
      );
      if (usersResponse.statusCode == 200) {
        final List<dynamic> usersData = json.decode(usersResponse.body);
        setState(() {
          _users = usersData;
        });
      } else {
        setState(() {
          _users = [];
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
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
      body: Column[
         childen: [
          Expanded(
             flex: 1,
            child: Center(
              child: Text(
                _status,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
               ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _users.isEmpty
              ? Center(child: Text('No users fetched yet or error.'))
              : ListView.builder(itemCount: _users.length,
                itemBuilder: (context, index) => {
                  final user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${user['id']}'),
                    ),
                    title: Text(user['name']),
                    subtitle: Text('Role: ${user['role']}'),
                   },
                 );
              }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Refresh Data'),
            ),
          ),
         ]
       ),
   );
  }
}
