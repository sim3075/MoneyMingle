class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? monthlyBudget;
  final double? savingsGoal;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
    this.monthlyBudget,
    this.savingsGoal,
  });

  factory User.fromMap(Map<String, dynamic> map, String uid) {
    return User(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      monthlyBudget: map['monthlyBudget'] != null
          ? (map['monthlyBudget'] as num).toDouble()
          : null,
      savingsGoal: map['savingsGoal'] != null
          ? (map['savingsGoal'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'monthlyBudget': monthlyBudget,
      'savingsGoal': savingsGoal,
    };
  }
}