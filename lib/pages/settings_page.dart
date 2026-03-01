import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_app_new/providers/results_provider.dart';
import 'package:gpa_app_new/providers/profile_provider.dart';
import 'package:gpa_app_new/models/profile.dart';
import 'package:gpa_app_new/providers/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool notifications = true;
  String language = 'English';
  String gpaScale = '4.0';

  @override
  Widget build(BuildContext context) {
    final isLightTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Title('Preferences'),
          _Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.dark_mode, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Switch between light and dark theme',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isLightTheme,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).state = value;
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                SwitchListTile(
                  value: notifications,
                  onChanged: (v) => setState(() => notifications = v),
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable reminders & alerts'),
                  secondary: const Icon(Icons.notifications_active),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(language),
                  trailing: DropdownButton<String>(
                    value: language,
                    underline: const SizedBox(),
                    items: ['English', 'Sinhala', 'Tamil']
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => language = v);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          _Title('GPA Settings'),
          _Card(
            child: ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('GPA Scale'),
              subtitle: const Text('Select your university GPA scale'),
              trailing: DropdownButton<String>(
                value: gpaScale,
                underline: const SizedBox(),
                items: ['4.0', '5.0']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => gpaScale = v);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),
          _Title('Data'),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restore, color: Colors.red),
                  title: const Text(
                    'Reset All Data',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Delete all saved results & profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showResetDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          _Title('About'),
          _Card(
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently delete all saved results and profile data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              // ✅ Actually clears SharedPreferences
              await ref.read(resultsProvider.notifier).clearAll();
              await ref
                  .read(profileProvider.notifier)
                  .save(
                    const ProfileData(
                      name: '',
                      degree: '',
                      university: '',
                      studentId: '',
                      email: '',
                      phone: '',
                      faculty: '',
                      batch: '',
                      department: '',
                    ),
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
  );
}
