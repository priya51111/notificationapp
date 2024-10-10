import 'package:flutter_bloc/flutter_bloc.dart';

import '../model.dart';
import '../repo/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuLoading()) {
    on<FetchMenuListEvent>(_onFetchMenuList);
    on<CreateMenuEvent>(_onCreateMenu);
  }

  Future<void> _onFetchMenuList(FetchMenuListEvent event, Emitter<MenuState> emit) async {
    try {
      emit(MenuLoading());
      final menuList = await menuRepository.getMenuList(event.userId, event.date);
      emit(MenuLoaded(menuList: menuList)); // Pass the fetched menu list here
    } catch (e) {
      print('Error fetching menu list: $e'); // Logging the error
      emit(MenuError(message: 'Failed to fetch menu list: ${e.toString()}'));
    }
  }

  // Method to handle menu creation
  Future<void> _onCreateMenu(CreateMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());  // Emit loading state while processing

    try {
      // Call the repository to create the menu
      final menuId = await menuRepository.createMenu(event.menuName, event.date);

      // Create a Menu object to represent the response
      final menu = Menus(menuId: menuId, menuName: event.menuName, date: event.date);

      // Emit success state with the created menu
      emit(MenuCreated(menu: menu));
    } catch (e) {
      // Emit error state in case of failure
      emit(MenuError(message: e.toString()));
    }
  }

}
