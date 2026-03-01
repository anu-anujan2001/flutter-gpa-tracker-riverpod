import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpa_app_new/models/result.dart';
import 'package:gpa_app_new/providers/results_provider.dart';

const _grades = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F'];
const _levels = [1, 2, 3, 4];

class AddResultSheet extends ConsumerStatefulWidget {
  const AddResultSheet({super.key});

  @override
  ConsumerState<AddResultSheet> createState() => _AddResultSheetState();
}

class _AddResultSheetState extends ConsumerState<AddResultSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl  = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _yearCtrl  = TextEditingController();

  int    _level      = 1;
  String _grade      = 'A';
  bool   _submitting = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final result = Result(
      id:    DateTime.now().millisecondsSinceEpoch.toString(),
      level: _level,
      code:  _codeCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      grade: _grade,
      year:  _yearCtrl.text.trim(),
    );

    await ref.read(resultsProvider.notifier).addResult(result);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ─────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Result',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Level + Grade row ─────────────────────────────────────────
            Row(
              children: [
                // Level dropdown
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _level,
                    decoration: _decor('Level'),
                    items: _levels
                        .map((l) => DropdownMenuItem(value: l, child: Text('Level $l')))
                        .toList(),
                    onChanged: (v) => setState(() => _level = v!),
                  ),
                ),
                const SizedBox(width: 12),
                // Grade dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _grade,
                    decoration: _decor('Grade'),
                    items: _grades
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _grade = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Course Code ───────────────────────────────────────────────
            TextFormField(
              controller: _codeCtrl,
              decoration: _decor('Course Code  e.g. CSC101S3'),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // ── Course Title ──────────────────────────────────────────────
            TextFormField(
              controller: _titleCtrl,
              decoration: _decor('Course Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // ── Academic Year ─────────────────────────────────────────────
            TextFormField(
              controller: _yearCtrl,
              decoration: _decor('Academic Year  e.g. 2024'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            // ── Submit button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_submitting ? 'Saving…' : 'Save Result'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decor(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

// ── Helper to open the sheet from anywhere ────────────────────────────────────
void showAddResultSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const AddResultSheet(),
  );
}
