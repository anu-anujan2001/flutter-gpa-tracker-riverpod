import 'package:flutter/material.dart';
import 'package:gpa_app_new/pages/dashboard_page.dart';
import 'package:gpa_app_new/pages/profile_details_page.dart';
import 'package:gpa_app_new/pages/results_page.dart';
import 'package:gpa_app_new/pages/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileDetailsPage()),
    );
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // ── AppBar ─────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        title: Text(_currentIndex == 0 ? 'GPA Tracker' : 'Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: _goToProfile,
          ),
        ],
      ),

      // ── Drawer ─────────────────────────────────────────
      drawer: Drawer(
        backgroundColor: scheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: scheme.onPrimary.withOpacity(0.2),
                      child: Icon(
                        Icons.school,
                        size: 40,
                        color: scheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'GPA Tracker',
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.dashboard, color: scheme.primary),
              title: const Text('Dashboard'),
              selected: _currentIndex == 0,
              selectedColor: scheme.primary,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),

            ListTile(
              leading: Icon(Icons.menu_book, color: scheme.primary),
              title: const Text('Results'),
              selected: _currentIndex == 1,
              selectedColor: scheme.primary,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),

            Divider(color: scheme.outlineVariant),

            ListTile(
              leading: Icon(Icons.person, color: scheme.primary),
              title: const Text('Profile'),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.pop(context);
                _goToProfile();
              },
            ),

            ListTile(
              leading: Icon(Icons.settings, color: scheme.primary),
              title: const Text('Settings'),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.pop(context);
                _goToSettings();
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
              ),
            ),
          ],
        ),
      ),

      // ── Body ─────────────────────────────────────────
      body: IndexedStack(
        index: _currentIndex,
        children: const [DashboardPage(), ResultsPage()],
      ),

      // ── Bottom Navigation ─────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Results',
          ),
        ],
      ),
    );
  }
}
