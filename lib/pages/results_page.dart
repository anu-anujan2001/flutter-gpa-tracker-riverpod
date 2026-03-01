import 'package:flutter/material.dart';
import 'package:gpa_app_new/levels/level1.dart';
import 'package:gpa_app_new/levels/level2.dart';
import 'package:gpa_app_new/levels/level3.dart';
import 'package:gpa_app_new/levels/level4.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Material(
            color: scheme.primary,
            child: TabBar(
              labelColor: scheme.onPrimary,
              unselectedLabelColor: scheme.onPrimary.withOpacity(0.7),
              indicatorColor: scheme.onPrimary,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Level 1'),
                Tab(text: 'Level 2'),
                Tab(text: 'Level 3'),
                Tab(text: 'Level 4'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [Level1(), Level2(), Level3(), Level4()],
            ),
          ),
        ],
      ),
    );
  }
}