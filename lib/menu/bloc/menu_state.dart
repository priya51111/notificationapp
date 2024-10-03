

import '../../task/model.dart';
import '../model.dart';

abstract class MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<Menus> menuList;

  MenuLoaded({required this.menuList});
}

class MenuAdded extends MenuState {
  final String menuId;

  MenuAdded({required this.menuId});
}
class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
