abstract class MenuEvent {}

class FetchMenuListEvent extends MenuEvent {
  final String userId;
  final String date;

  FetchMenuListEvent({required this.userId, required this.date});
}

class AddMenuEvent extends MenuEvent {    
  final String menuname;
  final String userId;
  final String date;

  AddMenuEvent({
    required this.menuname,
    required this.userId,
    required this.date,
  });
}

