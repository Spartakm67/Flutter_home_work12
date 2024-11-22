class Habit {
  final String id;
  final String name;
  final String frequency;
  final String startDate;
  final Map<String, bool> progress;
  final String userId;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.startDate,
    required this.progress,
    required this.userId,
  });

  factory Habit.fromFirestore(Map<String, dynamic> data) {
    return Habit(
      id: data['id'] as String,
      name: data['name'] as String,
      frequency: data['frequency'] as String,
      startDate: data['startDate'] as String,
      progress: Map<String, bool>.from(data['progress'] ?? {}),
      userId: data['userId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'startDate': startDate,
      'progress': progress,
      'userId': userId,
    };
  }
}
