import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_config/constants.dart';
import 'app_config/app_theme.dart';
import 'theme_notifier.dart';
import 'settings_screen.dart';
import 'user_card.dart';
import 'gender_filter.dart';
import 'sort_header.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Fetching...';
  List<dynamic> _users = [];
  String _searchQuery = '';
  late TextEditingController _searchController;
  Set<int> _selectedUserIds = {};
  String _genderFilter = 'all';
  bool _sortAsc = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_updateSearchQuery);
    _fetchServerStatus();
    _fetchUsers();
  }

  void _updateSearchQuery() {
    _searchQuery = _searchController.text;
    setState(() {});
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
    final url = '${Constants.webServiceBaseUrl}/api/users';
    try {
      final response = await http.get(Uri.parse(url));
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

  List<dynamic> _getFilteredUsers() {
    var filtered = List<dynamic>.from(_users);
    // Filter by gender
    if (_genderFilter != 'all') {
      filtered = filtered.where((u) => u['gender'] == _genderFilter).toList();
    }
    // Sort
    filtered.sort((a, b) {
      final nameA = (a['name'] as String?) ?? '';
      final nameB = (b['name'] as String?) ?? '';
      return _sortAsc ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });
    // Filter by search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((u) => ((u['name'] as String?) ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) || ((u['email'] as String?) ?? '').toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  Future<void> _deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('${Constants.webServiceBaseUrl}/api/users/$id'));
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
        Uri.parse('${Constants.webServiceBaseUrl}/api/users'),
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

  void _confirmDeleteSelected() {
    final theme = Theme.of(context);
    final selectedUsers = _users.where((u) => _selectedUserIds.contains(u['id'])).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, color: theme.colorScheme.error),
          title: const Text('Confirm Bulk Deletion'),
          content: Text('Are you sure you want to delete ${selectedUsers.length} users?'),
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
                await _deleteUsers(selectedUsers.map((u) => u['id'] as int).toList());
              },
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmDeleteSwipe(dynamic user) async {
    final theme = Theme.of(context);
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, color: theme.colorScheme.error),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${(user['name'] as String?) ?? 'Unknown'} forever?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _showUserDialog({Map<String, dynamic>? user}) async {
    final nameController = TextEditingController(text: (user?['name'] as String?) ?? '');
    final roleController = TextEditingController(text: (user?['role'] as String?) ?? '');
    final emailController = TextEditingController(text: (user?['email'] as String?) ?? '');
    String gender = (user?['gender'] as String?) ?? 'male';
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
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.wc)),
                items: ['male', 'female'].map((g) => DropdownMenuItem(value: g, child: Text(g[0].toUpperCase() + g.substring(1)))).toList(),
                onChanged: (value) => gender = value!,
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
      if (name.isEmpty || role.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
        return;
      }
      try {
        final body = json.encode({'name': name, 'role': role, 'email': email, 'gender': gender});
        final url = isEdit ? '${Constants.webServiceBaseUrl}/api/users/${user!['id']}' : '${Constants.webServiceBaseUrl}/api/users';
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

  Widget _buildUserList(List<dynamic> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final userId = (user['id'] as int?) ?? 0;
        final userName = (user['name'] as String?) ?? 'Unknown';
        final userEmail = (user['email'] as String?) ?? '';
        final userRole = (user['role'] as String?) ?? '';
        final userGender = (user['gender'] as String?) ?? 'male';
        final directUrl = 'https://i.pravatar.cc/150?img=$userId';
        final avatarUrl = kIsWeb 
          ? '${Constants.webServiceBaseUrl}/proxy/image?url=${Uri.encodeComponent(directUrl)}'
          : directUrl;
        return UserCard(
          name: userName,
          location: userEmail,
          avatarUrl: avatarUrl,
          tags: [userRole],
          gender: userGender,
          isSelected: _selectedUserIds.contains(userId),
          onTap: () {
            setState(() {
              if (_selectedUserIds.contains(userId)) {
                _selectedUserIds.remove(userId);
              } else {
                _selectedUserIds.add(userId);
              }
            });
          },
          onEdit: () => _showUserDialog(user: user),
          onDelete: () async {
            final confirmed = await _confirmDeleteSwipe(user);
            if (confirmed) {
              await _deleteUser(userId);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: theme.colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(child: Text(_status, style: theme.textTheme.headlineSmall)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _fetchServerStatus,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Status'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _fetchUsers,
                    icon: const Icon(Icons.people),
                    label: const Text('Refresh Users'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by name or email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                ),
              ),
            ),
            GenderFilter(
              selected: _genderFilter,
              onChanged: (value) {
                setState(() {
                  _genderFilter = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SortHeader(
              isAsc: _sortAsc,
              onTap: () {
                setState(() {
                  _sortAsc = !_sortAsc;
                });
              },
            ),
            if (_selectedUserIds.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _confirmDeleteSelected,
                  icon: const Icon(Icons.delete_forever),
                  label: Text('Delete Selected (${_selectedUserIds.length})'),
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
                ),
              ),
            ],
            Expanded(
              child: _buildUserList(_getFilteredUsers()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}