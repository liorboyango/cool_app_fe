        return UserCard(
          name: user['name'] ?? 'Unknown',
          location: user['location'] ?? '',
          avatarUrl: user['avatarUrl'] ?? '',
          tags: List<String>.from(user['tags'] ?? []),
          isSelected: selectedIds.contains(user['id']),
          onTap: () => onSelect(user['id']),
          onLongPress: () => onEdit(user),
        );
