class Menus {
  final String menuId;
  final String menuName;
  final String userId;
  final String date;

  Menus({
    required this.menuId,
    required this.menuName,
    required this.userId,
    required this.date,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      menuId: json['menuId'] as String,  // Explicitly cast to String
      menuName: json['menuName'] as String, // Explicitly cast to String
      userId: json['userId'] as String, // Explicitly cast to String
      date: json['date'] as String, // Explicitly cast to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'userId': userId,
      'date': date,
    };
  }
}
