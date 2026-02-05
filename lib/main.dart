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
import 'widgets/filter_sort_bar.dart';
import 'mixins/filter_sort_mixin.dart';
import 'models/user.dart';

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

class _MyHomePageState extends State<MyHomePage> with FilterSortMixin<User> {
  String _status = 'Fetching...';
  List<User> _users = [];
  String _searchQuery = '';
  Set<int> _selectedUserIds = {};
  SortOption _sortOption = SortOption.firstAsc;
  Set<String> _activeFilters = {};
  List<String> _filterOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchServerStatus();
    _fetchUsers();
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
          _users = data.map((d) => User.fromJson(d)).toList();
        });
        _updateFilterOptions();
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

  void _updateFilterOptions() {
    final genders = _users.map((u) => u.gender).toSet();
    final roles = _users.map((u) => u.role).toSet();
    setState(() {
      _filterOptions = [...genders, ...roles].toList();
    });
  }

  List<User> _getFilteredUsers() {
    return applyFilterSort(
      items: _users,
      query: _searchQuery,
      filters: _activeFilters,
      sort: _sortOption,
      getFirstName: (u) => u.firstName,
      getLastName: (u) => u.lastName,
      getFullName: (u) => u.fullName,
      getEmail: (u) => u.email,
      getCategories: (u) => {u.gender, u.role},
    );
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
    final selectedUsers = _users.where((u) => _selectedUserIds.contains(u.id)).toList();
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
          content: Text('Are you sure you want to delete ${user.fullName} forever?'),
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
    final firstNameController = TextEditingController(text: (user?.firstName ?? ''));
    final lastNameController = TextEditingController(text: (user?.lastName ?? ''));
    final roleController = TextEditingController(text: (user?.role ?? ''));
    final emailController = TextEditingController(text: (user?.email ?? ''));
    final phoneController = TextEditingController(text: (user?.phoneNumber ?? ''));
    final linkedinController = TextEditingController(text: (user?.linkedinUrl ?? ''));
    String gender = (user?.gender ?? 'male');
    final isEdit = user != null;
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit User' : 'Add User'),
          icon: Icon(isEdit ? Icons.edit : Icons.add, color: Theme.of(context).colorScheme.primary),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.work),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Role is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (E.164)',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '+1234567890',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\[\]]'), '');
                      final regex = RegExp(r'^\+?[1-9]\d{6,14}$');
                      if (!regex.hasMatch(cleaned)) {
                        return 'Invalid phone format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL (optional)',
                      prefixIcon: Icon(Icons.link),
                      hintText: 'https://linkedin.com/in/username',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: ['male', 'female'].map((g) => DropdownMenuItem(value: g, child: Text(g[0].toUpperCase() + g.substring(1)))).toList(),
                    onChanged: (value) => setState(() => gender = value!),
                    validator: (value) => value == null ? 'Gender is required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (formKey.currentState!.validate()) {
                  setState(() => isLoading = true);
                  Navigator.of(context).pop(true);
                }
              },
              child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final role = roleController.text.trim();
      final email = emailController.text.trim();
      final phoneNumber = phoneController.text.trim().isEmpty ? null : phoneController.text.trim();
      final linkedinUrl = linkedinController.text.trim().isEmpty ? null : linkedinController.text.trim();
      try {
        final body = json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'role': role,
          'email': email,
          'phoneNumber': phoneNumber,
          'linkedinUrl': linkedinUrl,
          'gender': gender,
        });
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
          firstName: user.firstName,
          lastName: user.lastName,
          location: '',
          avatarUrl: avatarUrl,
          tags: [user.role],
          gender: user.gender,
          email: user.email,
          phoneNumber: user.phoneNumber,
          linkedinUrl: user.linkedinUrl,
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
              child: FilterSortBar(
                searchQuery: _searchQuery,
                sortOption: _sortOption,
                activeFilters: _activeFilters,
                filterOptions: _filterOptions,
                onSearchChanged: (q) => setState(() => _searchQuery = q),
                onSortChanged: (s) => setState(() => _sortOption = s),
                onFiltersChanged: (f) => setState(() => _activeFilters = f),
              ),
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
}