import 'package:flutter/material.dart';

import 'user_card.dart';

class UsersGrid extends StatelessWidget {
  final List<dynamic> users;
  final Set<int> selectedIds;
  final Function(int) onSelect;
  final Function(dynamic) onEdit;

  const UsersGrid({
    super.key,
    required this.users,
    required this.selectedIds,
    required this.onSelect,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.6,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          name: user['name'],
          location: user['location'] ?? '',
          avatarUrl: user['avatarUrl'] ?? '',
          tags: List<String>.from(user['tags'] ?? []),
          isSelected: selectedIds.contains(user['id']),
          onTap: () => onSelect(user['id']),
          onLongPress: () => onEdit(user),
        );
      },
    );
  }
}
