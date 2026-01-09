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
