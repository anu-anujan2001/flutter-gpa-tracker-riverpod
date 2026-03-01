import 'package:flutter/material.dart';
import 'package:gpa_app_new/models/profile.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileData initial;
  const EditProfilePage({super.key, required this.initial});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl;
  late final TextEditingController degreeCtrl;
  late final TextEditingController universityCtrl;
  late final TextEditingController idCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController facultyCtrl;
  late final TextEditingController batchCtrl;
  late final TextEditingController deptCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    nameCtrl = TextEditingController(text: p.name);
    degreeCtrl = TextEditingController(text: p.degree);
    universityCtrl = TextEditingController(text: p.university);
    idCtrl = TextEditingController(text: p.studentId);
    emailCtrl = TextEditingController(text: p.email);
    phoneCtrl = TextEditingController(text: p.phone);
    facultyCtrl = TextEditingController(text: p.faculty);
    batchCtrl = TextEditingController(text: p.batch);
    deptCtrl = TextEditingController(text: p.department);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    degreeCtrl.dispose();
    universityCtrl.dispose();
    idCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    facultyCtrl.dispose();
    batchCtrl.dispose();
    deptCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.initial.copyWith(
      name: nameCtrl.text.trim(),
      degree: degreeCtrl.text.trim(),
      university: universityCtrl.text.trim(),
      studentId: idCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      faculty: facultyCtrl.text.trim(),
      batch: batchCtrl.text.trim(),
      department: deptCtrl.text.trim(),
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(context, "Name", nameCtrl),
            _field(context, "Degree", degreeCtrl),
            _field(context, "University", universityCtrl),
            _field(context, "Student ID", idCtrl),
            _field(context, "Email", emailCtrl, keyboard: TextInputType.emailAddress),
            _field(context, "Phone", phoneCtrl, keyboard: TextInputType.phone),
            _field(context, "Faculty", facultyCtrl),
            _field(context, "Batch", batchCtrl),
            _field(context, "Department", deptCtrl),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: scheme.surfaceContainerHighest.withOpacity(0.5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}