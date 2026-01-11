import 'package:flutter/material.dart';

import 'user.dart';
import 'user_card.dart';

class UsersGrid extends StatelessWidget {
  final List<User> users;
  final int? selectedIndex;
  final Function(int) onSelect;

  const UsersGrid({
    super.key,
    required this.users,
    this.selectedIndex,
    required this.onSelect,
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
          name: user.name,
          location: user.location,
          avatarUrl: user.avatarUrl,
          tags: user.tags,
          isSelected: selectedIndex == index,
          onTap: () => onSelect(index),
        );
      },
    );
  }
}
