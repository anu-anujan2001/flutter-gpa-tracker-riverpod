import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpa_app_new/models/profile.dart';

const _kProfileKey = 'profile_v1';

const _defaultProfile = ProfileData(
  name:       'Anu S.',
  degree:     'BSc (Hons) in Computer Science',
  university: 'University of _______',
  studentId:  'ICT/20/123',
  email:      'anu@gmail.com',
  phone:      '+94 7X XXX XXXX',
  faculty:    'Computing',
  batch:      '2020/2021',
  department: 'Computer Science',
);

class ProfileNotifier extends StateNotifier<ProfileData> {
  ProfileNotifier() : super(_defaultProfile) { _load(); }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw   = prefs.getString(_kProfileKey);
      if (raw != null) {
        state = ProfileData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (_) {}
  }

  Future<void> save(ProfileData profile) async {
    state = profile;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kProfileKey, jsonEncode(profile.toJson()));
    } catch (_) {}
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kProfileKey);
    } catch (_) {}
    state = _defaultProfile;
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileData>((ref) {
  return ProfileNotifier();
});
