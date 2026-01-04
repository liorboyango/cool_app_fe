import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'theme_notifier.dart';
import 'settings_screen.dart';

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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal.shade900,
              foregroundColor: Colors.white,
            ),
          ),
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
  List<dynamic> _users = [];
  String _searchQuery = '';
  String? _selectedRole;
  List<dynamic> _displayedUsers = [];
  late TextEditingController _searchController;
  Set<int> _selectedUserIds = {};
  bool _isLoadingStatus = false;
  bool _isLoadingUsers = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_updateSearchQuery);
    _fetchServerStatus();
    _fetchUsers();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  void _updateSearchQuery() {
    _searchQuery = _searchController.text;
    _updateDisplayedUsers();
  }

  Future<void> _fetchServerStatus() async {
    setState(() {
      _isLoadingStatus = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _status = 'Server is ${data['status']}';
        });
      } else {
        setState(() {
          _status = 'Server offline';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Connection failed';
      });
    } finally {
      setState(() {
        _isLoadingStatus = false;
      });
    }
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoadingUsers = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = data;
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
    } finally {
      setState(() {
        _isLoadingUsers = false;
      });
    }
  }

  void _updateDisplayedUsers() {
    var filtered = List<dynamic>.from(_users);
    if (_selectedRole != null) {
      filtered = filtered.where((u) => u['role'] == _selectedRole).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((u) => (u['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) || (u['email'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    filtered.sort((a, b) {
      final roleComp = (a['role'] as String).compareTo(b['role']);
      if (roleComp != 0) return roleComp;
      return (a['name'] as String).compareTo(b['name']);
    });
    setState(() {
      _displayedUsers = filtered;
      _selectedUserIds.removeWhere((id) => !_displayedUsers.any((u) => u['id'] == id));
    });
  }

  Future<void> _deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:3000/api/users/$id'));
      if (response.statusCode == 200) {
        await _fetchUsers();
        setState(() {
          _selectedUserIds.remove(id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteUsers(List<int> ids) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ids': ids}),
      );
      if (response.statusCode == 200) {
        await _fetchUsers();
        setState(() {
          _selectedUserIds.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete users')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _confirmDelete(dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${user['name']} forever?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUser(user['id']);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteSelected() {
    final selectedUsers = _displayedUsers.where((u) => _selectedUserIds.contains(u['id'])).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Bulk Deletion'),
          content: Text('Are you sure you want to delete ${selectedUsers.length} users?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUsers(selectedUsers.map((u) => u['id'] as int).toList());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUserDialog({Map<String, dynamic>? user}) async {
    final nameController = TextEditingController(text: user?['name'] ?? '');
    final roleController = TextEditingController(text: user?['role'] ?? '');
    final emailController = TextEditingController(text: user?['email'] ?? '');
    final isEdit = user != null;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit User' : 'Add User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
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
      if (name.isEmpty || role.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
        return;
      }
      try {
        final body = json.encode({'name': name, 'role': role, 'email': email});
        final url = isEdit ? 'http://localhost:3000/api/users/${user!['id']}' : 'http://localhost:3000/api/users';
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
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    return parts.length > 1 ? '${parts[0][0]}${parts[1][0]}' : name[0];
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.redAccent;
      case 'user':
        return Colors.blueAccent;
      case 'moderator':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Set<String> roles = _users.map((u) => u['role'] as String).toSet();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceVariant.withOpacity(0.5),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        _isLoadingStatus ? Icons.hourglass_empty : Icons.cloud_done,
                        color: _isLoadingStatus ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _status,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      if (_isLoadingStatus)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoadingStatus ? null : _fetchServerStatus,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Status'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoadingUsers ? null : _fetchUsers,
                      icon: const Icon(Icons.sync),
                      label: const Text('Refresh Users'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name or email',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Filter by role',
                  border: OutlineInputBorder(),
                ),
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
                  setState(() {
                    _selectedRole = newValue;
                    _updateDisplayedUsers();
                  });
                },
              ),
              if (_selectedUserIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: _confirmDeleteSelected,
                    icon: const Icon(Icons.delete_sweep),
                    label: Text('Delete Selected (${_selectedUserIds.length})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Users:',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_isLoadingUsers)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _displayedUsers.length,
                itemBuilder: (context, index) {
                  final user = _displayedUsers[index];
                  final isSelected = _selectedUserIds.contains(user['id']);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(user['role']),
                        child: Text(
                          _getInitials(user['name']),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? theme.colorScheme.primary : null,
                        ),
                      ),
                      subtitle: Text('Role: ${user['role']}\nEmail: ${user['email']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUserDialog(user: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(user),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          final id = user['id'];
                          if (_selectedUserIds.contains(id)) {
                            _selectedUserIds.remove(id);
                          } else {
                            _selectedUserIds.add(id);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add User',
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}