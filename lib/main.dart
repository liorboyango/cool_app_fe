import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_config/constants.dart';
import 'app_config/app_theme.dart';
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  String _status = 'Fetching...';
  List<dynamic> _users = [];
  String _searchQuery = '';
  String? _selectedRole;
  List<dynamic> _displayedUsers = [];
  late TextEditingController _searchController;
  Set<int> _selectedUserIds = {};
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_updateSearchQuery);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
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
    }
  }

  void _updateDisplayedUsers() {
    var filtered = List<dynamic>.from(_users);
    if (_selectedTabIndex != 0) {
      final roles = ['voter', 'editor', 'moderator'];
      _selectedRole = roles[_selectedTabIndex - 1];
      filtered = filtered.where((u) => u['role'] == _selectedRole).toList();
    } else {
      _selectedRole = null;
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
    final selectedUsers = _displayedUsers.where((u) => _selectedUserIds.contains(u['id'])).toList();
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
          content: Text('Are you sure you want to delete ${user['name']} forever?'),
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
    final nameController = TextEditingController(text: user?['name'] ?? '');
    final roleController = TextEditingController(text: user?['role'] ?? '');
    final emailController = TextEditingController(text: user?['email'] ?? '');
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
        final body = json.encode({'name': name, 'role': role, 'email': email});
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

  Widget _buildUserCard(Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final isSelected = _selectedUserIds.contains(user['id']);
    return InkWell(
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
      onLongPress: () => _showUserDialog(user: user),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: const Color(0xFF4A6CF7)) : null,
          boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                user['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D2939)),
            ),
            Text(
              user['location'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: (user['tags'] as List<dynamic>).map((t) => Chip(
                label: Text(t, style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7))),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF4A6CF7)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
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
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(child: Text(_status, style: theme.textTheme.headlineSmall)),
                ],
              ),
            ),
          ),
          Row(
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
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Reputation'),
              Tab(text: 'Voters'),
              Tab(text: 'Editors'),
              Tab(text: 'Moderators'),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
          ),
          if (_selectedUserIds.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _confirmDeleteSelected,
              icon: const Icon(Icons.delete_forever),
              label: Text('Delete Selected (${_selectedUserIds.length})'),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Users:', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: _displayedUsers.length,
              itemBuilder: (context, index) => _buildUserCard(_displayedUsers[index]),
            ),
          ),
        ],
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
    _tabController.dispose();
    super.dispose();
  }
}