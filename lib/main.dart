          SizedBox(height: 16),
          Text('Users:', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          UsersGrid(
            users: _displayedUsers,
            selectedIds: _selectedUserIds,
            onSelect: (id) {
              setState(() {
                if (_selectedUserIds.contains(id)) {
                  _selectedUserIds.remove(id);
                } else {
                  _selectedUserIds.add(id);
                }
              });
            },
            onEdit: (user) => _showUserDialog(user: user),
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
