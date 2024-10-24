class Tasks {
  final String id;
  final String task;
  final String date;
  final String time;
  final String  menuId;  // To store the array of menuId objects

  Tasks({
    required this.id,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,  // Add this
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['_id'],
      task: json['task'],
      date: json['date'],
      time: json['time'],
      menuId: json['menuId'],
    );
  }
}

