                CircleAvatar(
                  radius: 28,
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty && name.isNotEmpty ? Text(name[0].toUpperCase(), style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)) : (avatarUrl.isEmpty ? const Icon(Icons.person) : null),
                  backgroundColor: theme.colorScheme.primary,
                ),
