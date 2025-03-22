class Habit {
  int? id;
  String name;
  int color;
  double goal;
  String detail;
  String unit;
  String icon; 

  Habit({
    this.id,
    required this.name,
    required this.color,
    required this.goal,
    required this.detail,
    required this.unit,
    required this.icon, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'goal': goal,
      'detail': detail,
      'unit': unit,
      'icon': icon, 
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      goal: map['goal'],
      detail: map['detail'],
      unit: map['unit'],
      icon: map['icon'], 
  }
}