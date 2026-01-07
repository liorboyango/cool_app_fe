import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_notifier.dart';
import 'theme_toggle.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  themeNotifier.toggleTheme(themeNotifier.themeMode != ThemeMode.dark);
                },
                trailing: ThemeToggle(
                  isDark: themeNotifier.themeMode == ThemeMode.dark,
                  onToggle: themeNotifier.toggleTheme,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
