import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpa_app_new/models/result.dart';

const _kResultsKey = 'results_v1';

class ResultsState {
  final List<Result> results;
  final bool isLoading;
  const ResultsState({required this.results, required this.isLoading});
  ResultsState copyWith({List<Result>? results, bool? isLoading}) =>
      ResultsState(
        results: results ?? this.results,
        isLoading: isLoading ?? this.isLoading,
      );
}

class ResultsNotifier extends StateNotifier<ResultsState> {
  ResultsNotifier() : super(const ResultsState(results: [], isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kResultsKey);
      if (raw != null && raw.isNotEmpty) {
        state = ResultsState(results: Result.decodeList(raw), isLoading: false);
      } else {
        state = ResultsState(results: _seedData(), isLoading: false);
        await _save();
      }
    } catch (_) {
      state = ResultsState(results: _seedData(), isLoading: false);
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kResultsKey, Result.encodeList(state.results));
    } catch (_) {}
  }

  Future<void> addResult(Result result) async {
    state = state.copyWith(results: [...state.results, result]);
    await _save();
  }

  Future<void> deleteResult(String id) async {
    state = state.copyWith(
      results: state.results.where((item) => item.id != id).toList(),
    );
    await _save();
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kResultsKey);
    } catch (_) {}
    state = const ResultsState(results: [], isLoading: false);
  }

  double gpaForLevel(int level) {
    final lvl = state.results.where((item) => item.level == level).toList();
    if (lvl.isEmpty) return 0.0;
    return lvl.map((item) => item.points).reduce((a, b) => a + b) / lvl.length;
  }

  double get overallGpa {
    if (state.results.isEmpty) return 0.0;
    return state.results.map((item) => item.points).reduce((a, b) => a + b) /
        state.results.length;
  }

  List<Result> resultsForLevel(int level) =>
      state.results.where((item) => item.level == level).toList();
}

final resultsProvider = StateNotifierProvider<ResultsNotifier, ResultsState>((
  ref,
) {
  return ResultsNotifier();
});

List<Result> _seedData() => [];
