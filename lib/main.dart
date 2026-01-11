  void _updateDisplayedUsers() {
    var filtered = List<dynamic>.from(_users);
    _selectedRole = null;
    if (_selectedTabIndex == 1) {
      _selectedRole = 'voter';
    } else if (_selectedTabIndex == 2) {
      _selectedRole = 'editor';
    } else if (_selectedTabIndex == 3) {
      _selectedRole = 'moderator';
    }
    if (_selectedRole != null) {
      filtered = filtered.where((u) => u['role'] == _selectedRole).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((u) => (u['name'] as String?)?.toLowerCase().contains(_searchQuery.toLowerCase()) == true || (u['email'] as String?)?.toLowerCase().contains(_searchQuery.toLowerCase()) == true).toList();
    }
    filtered.sort((a, b) {
      final roleA = a['role'] as String? ?? '';
      final roleB = b['role'] as String? ?? '';
      final roleComp = roleA.compareTo(roleB);
      if (roleComp != 0) return roleComp;
      final nameA = a['name'] as String? ?? '';
      final nameB = b['name'] as String? ?? '';
      return nameA.compareTo(nameB);
    });
    setState(() {
      _displayedUsers = filtered;
      _selectedUserIds.removeWhere((id) => !_displayedUsers.any((u) => u['id'] == id));
    });
  }