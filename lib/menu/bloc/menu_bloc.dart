import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';
import 'package:get_storage/get_storage.dart';  // Import GetStorage


class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final GetStorage box = GetStorage();  // Initialize GetStorage instance

  MenuBloc({required this.menuRepository}) : super(MenuInitial()) {
    on<CreateMenuEvent>(_onCreateMenu);
    on<FetchMenuListEvent>(_onFetchMenuList);
  }

  // Handle creating a new menu using Future and emit
  Future<void> _onCreateMenu(
    CreateMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());

    try {
      final userId = box.read('userId');  // Fetch userId from GetStorage
      if (userId == null) {
        emit(MenuError(message: 'User ID is missing'));
        return;
      }

      final menuId = await menuRepository.createMenu(event.menuName, event.date);
      emit(MenuCreated(menuId: menuId)); // Pass the created menuId
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  // Handle fetching the menu list using Future and emit
  Future<void> _onFetchMenuList(
    FetchMenuListEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());

    try {
      final userId = box.read('userId');  // Fetch userId from GetStorage
      if (userId == null) {
        emit(MenuError(message: 'User ID is missing'));
        return;
      }

      final menuList = await menuRepository.getMenuList(userId, event.date);  // Pass userId here
      emit(MenuLoaded(menuList: menuList)); // Emit the loaded menu list
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}
