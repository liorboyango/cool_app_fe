import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String location;
  final String avatarUrl;
  final List<String> tags;
  final String gender;
  final String email;
  final String? phoneNumber;
  final String? facebookUrl;
  final String? linkedinUrl;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.firstName,
    required this.lastName,
    this.location = '',
    required this.avatarUrl,
    required this.tags,
    required this.gender,
    required this.email,
    this.phoneNumber,
    this.facebookUrl,
    this.linkedinUrl,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40, // Increased from default ~20 to 40 for 80x80
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                backgroundColor: avatarUrl.isNotEmpty ? null : theme.colorScheme.primary,
                child: avatarUrl.isNotEmpty ? null : Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Adjusted for larger avatar
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    if (location.isNotEmpty) Text(location),
                    // Tappable email address
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _launchUrl('mailto:$email'),
                        child: Text(
                          email,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    Wrap(
                      spacing: 6,
                      children: tags.map((tag) => _buildTag(tag, theme)).toList(),
                    ),
                    if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        phoneNumber!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _CallButton(
                            icon: Icons.phone,
                            color: const Color(0xFF007AFF),
                            onTap: () => _launchUrl('tel:$phoneNumber'),
                          ),
                          const SizedBox(width: 8),
                          _CallButton(
                            icon: Icons.chat,
                            color: const Color(0xFF25D366),
                            onTap: () => _launchUrl('https://wa.me/${phoneNumber!.replaceAll(RegExp(r'[^0-9]'), '')}'),
                          ),
                        ],
                      ),
                    ],
                    // Facebook button
                    if (facebookUrl != null && facebookUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl(facebookUrl!),
                        icon: const Icon(Icons.facebook, size: 20),
                        label: const Text('Facebook'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                    // LinkedIn button
                    if (linkedinUrl != null && linkedinUrl!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl(linkedinUrl!),
                        icon: const Icon(Icons.business, size: 20),
                        label: const Text('LinkedIn'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A66C2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
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
                  if (onEdit != null) ...[
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Edit user',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}