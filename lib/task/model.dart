import '../menu/model.dart';

class Task {
  final String? taskId;
  final String task;
  final String date;
  final String time;
  final List<Menus> menuId;  // List of Menus
  final String userId;
  bool isChecked;

  Task({
    this.taskId,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
    required this.userId,
    this.isChecked = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    var menuFromJson = json['menuId'] as List;
    List<Menus> menuList = menuFromJson.map((i) => Menus.fromJson(i)).toList();

    return Task(
      taskId: json['taskId'] as String?,
      task: json['task'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      menuId: menuList,  // Assign list of Menus
      userId: json['userId'] as String,
      isChecked: json['isChecked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'task': task,
      'date': date,
      'time': time,
      'userId': userId,
      'menuId': menuId.map((menu) => menu.toJson()).toList(),  // Convert list of Menus to JSON
      'isChecked': isChecked,
    };
  }

  Task copyWith({
    String? taskId,
    String? task,
    String? date,
    String? time,
    List<Menus>? menuId,
    String? userId,
    bool? isChecked,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      task: task ?? this.task,
      date: date ?? this.date,
      time: time ?? this.time,
      menuId: menuId ?? this.menuId,
      userId: userId ?? this.userId,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
