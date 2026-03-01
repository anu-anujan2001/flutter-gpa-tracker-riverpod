class ProfileData {
  final String name;
  final String degree;
  final String university;
  final String studentId;
  final String email;
  final String phone;
  final String faculty;
  final String batch;
  final String department;

  const ProfileData({
    required this.name,
    required this.degree,
    required this.university,
    required this.studentId,
    required this.email,
    required this.phone,
    required this.faculty,
    required this.batch,
    required this.department,
  });

  ProfileData copyWith({
    String? name,
    String? degree,
    String? university,
    String? studentId,
    String? email,
    String? phone,
    String? faculty,
    String? batch,
    String? department,
  }) => ProfileData(
    name: name ?? this.name,
    degree: degree ?? this.degree,
    university: university ?? this.university,
    studentId: studentId ?? this.studentId,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    faculty: faculty ?? this.faculty,
    batch: batch ?? this.batch,
    department: department ?? this.department,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'degree': degree,
    'university': university,
    'studentId': studentId,
    'email': email,
    'phone': phone,
    'faculty': faculty,
    'batch': batch,
    'department': department,
  };

  factory ProfileData.fromJson(Map<String, dynamic> j) => ProfileData(
    name: j['name'] ?? '',
    degree: j['degree'] ?? '',
    university: j['university'] ?? '',
    studentId: j['studentId'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'] ?? '',
    faculty: j['faculty'] ?? '',
    batch: j['batch'] ?? '',
    department: j['department'] ?? '',
  );
}
