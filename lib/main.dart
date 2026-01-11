import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_config/constants.dart';
import 'app_config/app_theme.dart';
import 'theme_notifier.dart';
import 'settings_screen.dart';
import 'users_grid.dart';
import 'user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Coolest App Ever',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themeMode,
          home: const MyHomePage(title: 'Coolest Main Screen Ever!'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _status = 'Fetching...';
  List<User> _users = [];
  String _searchQuery = '';
  String? _selectedRole;
  List<User> _displayedUsers = [];
  late TextEditingController _searchController;
  int? _selectedUserIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_updateSearchQuery);
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        final roles = [null, 'Reputation', 'Voters', 'Editors', 'Moderators'];
        _selectedRole = roles[_tabController.index];
        _updateDisplayedUsers();
      });
    });
    _fetchServerStatus();
    _fetchUsers();
  }

  void _updateSearchQuery() {
    _searchQuery = _searchController.text;
    _updateDisplayedUsers();
  }

  Future<void> _fetchServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.webServiceBaseUrl}/api/status'),
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
      final response = await http.get(Uri.parse('${Constants.webServiceBaseUrl}/api/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = data.map((u) => User.fromJson(u)).toList();
          _updateDisplayedUsers();
        });
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
    var filtered = List<User>.from(_users);
    if (_selectedRole != null) {
      filtered = filtered.where((u) => u.role == _selectedRole).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((u) => u.name.toLowerCase().contains(_searchQuery.toLowerCase()) || u.email.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    filtered.sort((a, b) {
      final roleComp = a.role.compareTo(b.role);
      if (roleComp != 0) return roleComp;
      return a.name.compareTo(b.name);
    });
    setState(() {
      _displayedUsers = filtered;
      // Adjust selected index if out of bounds
      if (_selectedUserIndex != null && _selectedUserIndex! >= _displayedUsers.length) {
        _selectedUserIndex = null;
      }
    });
  }

  Future<void> _deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('${Constants.webServiceBaseUrl}/api/users/$id'));
      if (response.statusCode == 200) {
        await _fetchUsers();
        setState(() {
          _selectedUserIndex = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      });
    }
  }

  void _confirmDeleteSelected() {
    final theme = Theme.of(context);
    if (_selectedUserIndex == null) return;
    final selectedUser = _displayedUsers[_selectedUserIndex!];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, color: theme.colorScheme.error),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${selectedUser.name} forever?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUser(selectedUser.id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUserDialog({User? user}) async {
    final nameController = TextEditingController(text: user?.name ?? '');
    final roleController = TextEditingController(text: user?.role ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final locationController = TextEditingController(text: user?.location ?? '');
    final isEdit = user != null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit User' : 'Add User'),
        icon: Icon(isEdit ? Icons.edit : Icons.add, color: Theme.of(context).colorScheme.primary),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.work)),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      final name = nameController.text.trim();
      final role = roleController.text.trim();
      final email = emailController.text.trim();
      final location = locationController.text.trim();
      if (name.isEmpty || role.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
        return;
      }
      try {
        final body = json.encode({'name': name, 'role': role, 'email': email, 'location': location});
        final url = isEdit ? '${Constants.webServiceBaseUrl}/api/users/${user!.id}' : '${Constants.webServiceBaseUrl}/api/users';
        final method = isEdit ? http.put : http.post;
        final response = await method(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          await _fetchUsers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEdit ? 'User updated' : 'User added')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save user')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Set<String> roles = _users.map((u) => u.role).toSet();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info, color: theme.colorScheme.primary),
                  SizedBox(width: 16),
                  Expanded(child: Text(_status, style: theme.textTheme.headlineSmall)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _fetchServerStatus,
                icon: Icon(Icons.refresh),
                label: Text('Refresh Status'),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _fetchUsers,
                icon: Icon(Icons.people),
                label: Text('Refresh Users'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by name or email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Reputation'),
                      Tab(text: 'Voters'),
                      Tab(text: 'Editors'),
                      Tab(text: 'Moderators'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_selectedUserIndex != null) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _confirmDeleteSelected,
              icon: Icon(Icons.delete_forever),
              label: Text('Delete Selected'),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
          SizedBox(height: 16),
          Text('Users:', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          UsersGrid(
            users: _displayedUsers,
            selectedIndex: _selectedUserIndex,
            onSelect: (index) {
              setState(() {
                _selectedUserIndex = _selectedUserIndex == index ? null : index;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        icon: Icon(Icons.add),
        label: Text('Add User'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
