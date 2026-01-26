import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String location;
  final String avatarUrl;
  final List<String> tags;
  final String gender;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.tags,
    required this.gender,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          backgroundColor: avatarUrl.isNotEmpty ? null : theme.colorScheme.primary,
          child: avatarUrl.isNotEmpty ? null : Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (location.isNotEmpty) Text(location),
            Wrap(
              spacing: 6,
              children: tags.map((tag) => _buildTag(tag, theme)).toList(),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getBadgeColor(gender, isDark),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            gender.toLowerCase() == 'male' ? 'M' : 'F',
            style: TextStyle(
              color: _getBadgeTextColor(gender, isDark),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        selected: isSelected,
        onTap: onTap,
        onLongPress: onDelete,
      ),
    );
  }

  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Color _getBadgeColor(String gender, bool isDark) {
    if (gender.toLowerCase() == 'female') {
      return isDark ? const Color(0xFF5C2D4A) : const Color(0xFFFFE0EB);
    }
    return isDark ? const Color(0xFF1E3A5F) : const Color(0xFFE0F0FF);
  }

  Color _getBadgeTextColor(String gender, bool isDark) {
    if (gender.toLowerCase() == 'female') {
      return isDark ? const Color(0xFFFFB8D4) : const Color(0xFFAD1457);
    }
    return isDark ? const Color(0xFF90CAF9) : const Color(0xFF1565C0);
  }
}