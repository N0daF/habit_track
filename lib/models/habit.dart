class Habit {
  final int? id;
  final String name;
  final double progress;
  final int color; // เพิ่มฟิลด์สำหรับสี

  Habit({
    this.id,
    required this.name,
    required this.progress,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'progress': progress,
      'color': color,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      progress: map['progress'],
      color: map['color'],
    );
  }
}