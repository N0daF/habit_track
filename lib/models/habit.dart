class Habit {
  final int? id;
  final String name;
  final double progress;
  final int color;
  final double goal;
  final String detail; // รายละเอียดของ Habit
  final String unit;   // หน่วยของ Goal

  Habit({
    this.id,
    required this.name,
    required this.progress,
    required this.color,
    required this.goal,
    required this.detail,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'progress': progress,
      'color': color,
      'goal': goal,
      'detail': detail,
      'unit': unit,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      progress: map['progress'],
      color: map['color'],
      goal: map['goal'],
      detail: map['detail'],
      unit: map['unit'],
    );
  }
}