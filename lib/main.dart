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
  String _searchQuery = '';
  String? _selectedRole;
  List<dynamic> _displayedUsers = [];

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
        _updateDisplayedUsers();
      } else {
        setState(() {
          _users = [];
          _displayedUsers = [];
        });
      }
    } catch (e) {
      setState(() {
        _users = [];
        _displayedUsers = [];
      });
    }
  }

  void _updateDisplayedUsers() {
    var filtered = List<dynamic>.from(_users);
    if (_selectedRole != null) {
      filtered = filtered.where((u) => u['role'] == _selectedRole).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((u) => (u['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    filtered.sort((a, b) {
      final roleComp = (a['role'] as String).compareTo(b['role']);
      if (roleComp != 0) return roleComp;
      return (a['name'] as String).compareTo(b['name']);
    });
    setState(() {
      _displayedUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Set<String> roles = _users.map((u) => u['role'] as String).toSet();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _updateDisplayedUsers();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButton<String?>(
              value: _selectedRole,
              hint: const Text('Filter by role'),
              isExpanded: true,
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All'),
                ),
              ] + roles.map<DropdownMenuItem<String?>>((String role) {
                return DropdownMenuItem<String?>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _selectedRole = newValue;
                _updateDisplayedUsers();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text('Users:', style: theme.textTheme.headlineSmall),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _displayedUsers.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(_displayedUsers[index]['name']),
              subtitle: Text('Role: ${_displayedUsers[index]['role']}'),
            ),
          ),
        ],
      ),
    );
  }
}
