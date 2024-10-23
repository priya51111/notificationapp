class Menus {
  
  final String menuName;
  final String date;

  Menus({
    
    required this.menuName,
    required this.date,
  });

  // Factory constructor to create a Menu from JSON
  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
    
      menuName: json['menuName'],
      date: json['date'],
    );
  }

  // Convert Menu instance to JSON
  Map<String, dynamic> toJson() {
    return {
    
      'menuName': menuName,
      'date': date,
    };
  }
}
