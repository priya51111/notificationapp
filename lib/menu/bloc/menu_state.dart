

import '../../task/model.dart';
import '../model.dart';

abstract class MenuState {}
class MenuInitial extends MenuState{}
class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<Menus> menuList;

  MenuLoaded({required this.menuList});
}

class MenuCreated extends MenuState {
  final Menus menu;

  MenuCreated({required this.menu});
}
class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
