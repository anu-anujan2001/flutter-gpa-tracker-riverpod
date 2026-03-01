import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_app_new/models/result.dart';
import 'package:gpa_app_new/providers/results_provider.dart';
import 'package:gpa_app_new/widgets/add_result_sheet.dart';

class LevelResultsList extends ConsumerWidget {
  final int level;
  const LevelResultsList({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    final state = ref.watch(resultsProvider);
    final results = state.results.where((item) => item.level == level).toList();

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              'No results yet.',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Result'),
              onPressed: () => showAddResultSheet(context),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: scheme.surfaceContainerHighest,
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Course\nCode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Course Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Grade',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Acad\nYear',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final isEven = index % 2 == 0;

                  final rowColor = isEven
                      ? scheme.surfaceContainerHighest.withOpacity(0.55)
                      : scheme.surface;

                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: scheme.error,
                      child: Icon(Icons.delete, color: scheme.onError),
                    ),
                    onDismissed: (_) {
                      ref.read(resultsProvider.notifier).deleteResult(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.code} removed')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      color: rowColor,
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text(item.code)),
                          const SizedBox(width: 10),
                          Expanded(flex: 6, child: Text(item.title)),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.grade,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _gradeColor(item.grade, scheme),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(flex: 2, child: Text(item.year)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Floating button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            icon: const Icon(Icons.add),
            label: const Text('Add Result'),
            onPressed: () => showAddResultSheet(context),
          ),
        ),
      ],
    );
  }

  Color _gradeColor(String grade, ColorScheme scheme) {
    final pts = Result.gradePoint(grade);

    // Keep your same meaning colors, but make them theme-aware.
    // If you want, we can also map these to scheme.tertiary/etc.
    if (pts >= 3.7) return Colors.green.shade700;
    if (pts >= 3.0) return Colors.blue.shade700;
    if (pts >= 2.0) return Colors.orange.shade700;
    return scheme.error;
  }
}