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