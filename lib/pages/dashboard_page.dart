import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gpa_app_new/providers/results_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state    = ref.watch(resultsProvider);
    final notifier = ref.read(resultsProvider.notifier);
    const maxGpa   = 4.0;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final overallGpa = notifier.overallGpa;
    final overallPct = (overallGpa / maxGpa).clamp(0.0, 1.0);
    const colors = [Colors.blueAccent, Colors.redAccent, Colors.green, Colors.purpleAccent];

    return Container(
      color: const Color(0xFFF2F4F8),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            elevation: 15,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              child: Column(
                children: [
                  const Text('G P A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 18),
                  CircularPercentIndicator(
                    radius: 86, lineWidth: 20,
                    percent: overallPct,
                    animation: true, animationDuration: 900,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.deepPurple,
                    backgroundColor: Colors.deepPurple.shade100,
                    center: Text(overallGpa.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('Cumulative GPA',
                          style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Divider(thickness: 1.2),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12,
                      mainAxisSpacing: 12, childAspectRatio: 0.9,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      final level   = i + 1;
                      final gpa     = notifier.gpaForLevel(level);
                      final percent = (gpa / maxGpa).clamp(0.0, 1.0);
                      return _LevelCard(
                        label:   'Level-$level GPA',
                        gpaText: gpa.toStringAsFixed(2),
                        percent: percent,
                        color:   colors[i],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String label;
  final String gpaText;
  final double percent;
  final Color  color;
  const _LevelCard({required this.label, required this.gpaText,
      required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Center(
        child: CircularPercentIndicator(
          radius: 52, lineWidth: 12,
          percent: percent.clamp(0.0, 1.0),
          animation: true, animationDuration: 900,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: Colors.deepPurple.shade100,
          center: Text(gpaText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          footer: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
          ),
        ),
      ),
    );
  }
}
