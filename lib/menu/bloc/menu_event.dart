abstract class MenuEvent {}

class FetchMenuListEvent extends MenuEvent {
  final String userId;
  final String date;

  FetchMenuListEvent({required this.userId, required this.date});
}

// Event to create a menu
class CreateMenuEvent extends MenuEvent {
  final String menuName;
  final String date;

CreateMenuEvent({required this.menuName, required this.date});

  
}

