  Widget _buildUserCard(Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final isSelected = _selectedUserIds.contains(user['id']);
    final name = user['name'] as String? ?? 'Unknown';
    final location = 'Location ${user['id']}';
    final tags = [user['role'] as String? ?? 'user'];
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
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D2939)),
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: tags.map((t) => Chip(
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