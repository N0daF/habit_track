class HabitHistory {
  final int? id;
  final int habitId;
  final String date; // เก็บวันที่ในรูปแบบ "yyyy-MM-dd"
  final double progressAdded;

  HabitHistory({
    this.id,
    required this.habitId,
    required this.date,
    required this.progressAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date,
      'progressAdded': progressAdded,
    };
  }

  factory HabitHistory.fromMap(Map<String, dynamic> map) {
    return HabitHistory(
      id: map['id'],
      habitId: map['habitId'],
      date: map['date'],
      progressAdded: map['progressAdded'],
    );
  }
}
