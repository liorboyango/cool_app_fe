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
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.work),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Role is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (E.164)',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '+1234567890',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final cleaned = value.replaceAll(RegExp(r'[ \s\-\(\)\[\]]'), '');
                      final regex = RegExp(r'^\+?[1-9]\d{6,14}$');
                      if (!regex.hasMatch(cleaned)) {
                        return 'Invalid phone format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL',
                      prefixIcon: Icon(Icons.link),
                      hintText: 'https://linkedin.com/in/username',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        final body = json.encode({'firstName': firstName, 'lastName': lastName, 'role': role, 'email': email, 'phoneNumber': phoneNumber, 'linkedinUrl': linkedinUrl, 'gender': gender});
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