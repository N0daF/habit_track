class Habit {
  final int? id;
  final String name;
  final double progress;

  Habit({this.id, required this.name, required this.progress});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'progress': progress,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      progress: map['progress'],
    );
  }
}