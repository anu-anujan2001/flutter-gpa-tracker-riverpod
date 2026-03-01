import 'dart:convert';

class Result {
  final String id;
  final int level;
  final String code;
  final String title;
  final String grade;
  final String year;

  Result({
    required this.id,
    required this.level,
    required this.code,
    required this.title,
    required this.grade,
    required this.year,
  });

  static double gradePoint(String grade) {
    switch (grade.trim().toUpperCase()) {
      case 'A+': return 4.0;
      case 'A':  return 4.0;
      case 'A-': return 3.7;
      case 'B+': return 3.3;
      case 'B':  return 3.0;
      case 'B-': return 2.7;
      case 'C+': return 2.3;
      case 'C':  return 2.0;
      case 'C-': return 1.7;
      case 'D+': return 1.3;
      case 'D':  return 1.0;
      default:   return 0.0;
    }
  }

  double get points => gradePoint(grade);

  Map<String, dynamic> toJson() => {
    'id':    id,
    'level': level,
    'code':  code,
    'title': title,
    'grade': grade,
    'year':  year,
  };

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id:    json['id']    as String,
    level: json['level'] as int,
    code:  json['code']  as String,
    title: json['title'] as String,
    grade: json['grade'] as String,
    year:  json['year']  as String,
  );

  static String encodeList(List<Result> list) =>
      jsonEncode(list.map((item) => item.toJson()).toList());

  static List<Result> decodeList(String source) {
    try {
      return (jsonDecode(source) as List)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
