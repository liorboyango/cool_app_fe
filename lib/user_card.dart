import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String location;
  final String avatarUrl;
  final List<String> tags;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.tags,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4B7BF5) : const Color(0xFFE8EDF2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0xD4, 0xDC, 0xE8, 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2B4A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7A99),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD4DCE8)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4B7BF5),
        ),
      ),
    );
  }
}
