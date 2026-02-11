import 'package:flutter/material.dart';

/// A modern card widget that displays status and time information
/// with improved visual design and theme integration.
class StatusTimeCard extends StatelessWidget {
  final String status;
  final DateTime time;
  final bool isActive;

  const StatusTimeCard({
    super.key,
    required this.status,
    required this.time,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle_outline : Icons.schedule,
            color: isActive ? Colors.green : colorScheme.outline,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(time),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          _buildBadge(isActive, colorScheme),
        ],
      ),
    );
  }

  /// Builds the status badge (Active/Inactive)
  Widget _buildBadge(bool active, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withOpacity(0.12)
            : colorScheme.outline.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: active ? Colors.green : colorScheme.outline,
        ),
      ),
    );
  }

  /// Formats the time in a user-friendly format (e.g., "12:34 PM · Today")
  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    
    // Calculate if it's today
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final dayLabel = isToday ? 'Today' : '${dt.month}/${dt.day}/${dt.year}';
    
    return '$hour:$minute $period · $dayLabel';
  }
}
