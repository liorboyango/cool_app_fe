import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_config/constants.dart';
import 'app_config/app_theme.dart';
import 'theme_notifier.dart';
import 'settings_screen.dart';
import 'user_card.dart';
import 'widgets/filter_controls.dart';
import 'providers/users_provider.dart';
import 'providers/filtered_users_provider.dart';
import 'models/user.dart';

void main() {
  runApp(
    ProviderScope(
      child: ChangeNotifierProvider(
        create: (context) => ThemeNotifier(),
        child: const MyApp(),
      ),
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String _status = 'Fetching...';
  Set<int> _selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    _fetchServerStatus();
  }

  Future<void> _fetchServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.webServiceBaseUrl}/api/status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _status = 'Status: ${data['status']}, Time: ${data['timestamp']};
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

  Future<void> _deleteUser(int id) async {
    try {
      await ref.read(usersNotifierProvider.notifier).deleteUser(id);
      setState(() {
        _selectedUserIds.remove(id);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteUsers(List<int> ids) async {
    try {
      await ref.read(usersNotifierProvider.notifier).deleteUsers(ids);
      setState(() {
        _selectedUserIds.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _confirmDeleteSelected() {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(usersNotifierProvider);
    final users = usersAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <User>[],
    );
    final selectedUsers = users.where((u) => _selectedUserIds.contains(u.id)).toList();
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
                await _deleteUsers(selectedUsers.map((u) => u.id).toList());
              },
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.error),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmDeleteSwipe(User user) async {
    final theme = Theme.of(context);
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, color: theme.colorScheme.error),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${user.name} forever?'),
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

  Future<void> _showUserDialog({User? user}) async {
    final nameController = TextEditingController(text: user?.name ?? '');
    final roleController = TextEditingController(text: user?.role ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    String gender = user?.gender ?? 'male';
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
      final newUser = User(
        id: user?.id ?? 0, // Will be ignored for add
        name: name,
        role: role,
        email: email,
        gender: gender,
      );
      try {
        if (isEdit) {
          await ref.read(usersNotifierProvider.notifier).updateUser(newUser);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated')),
          );
        } else {
          await ref.read(usersNotifierProvider.notifier).addUser(newUser);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User added')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildUserList(List<User> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final directUrl = 'https://i.pravatar.cc/150?img=${user.id}';
        final avatarUrl = kIsWeb
          ? '${Constants.webServiceBaseUrl}/proxy/image?url=${Uri.encodeComponent(directUrl)}'
          : directUrl;
        return UserCard(
          name: user.name,
          location: user.email,
          avatarUrl: avatarUrl,
          tags: [user.role],
          gender: user.gender,
          isSelected: _selectedUserIds.contains(user.id),
          onTap: () {
            setState(() {
              if (_selectedUserIds.contains(user.id)) {
                _selectedUserIds.remove(user.id);
              } else {
                _selectedUserIds.add(user.id);
              }
            });
          },
          onEdit: () => _showUserDialog(user: user),
          onDelete: () async {
            final confirmed = await _confirmDeleteSwipe(user);
            if (confirmed) {
              await _deleteUser(user.id);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredUsers = ref.watch(filteredUsersProvider);
    final usersAsync = ref.watch(usersNotifierProvider);

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
                    onPressed: usersAsync.isLoading ? null : () => ref.invalidate(usersNotifierProvider),
                    icon: const Icon(Icons.people),
                    label: const Text('Refresh Users'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilterControls(),
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
              child: usersAsync.when(
                data: (_) => _buildUserList(filteredUsers),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
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
}