import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:get_storage/get_storage.dart';

import 'package:notificationapp/login/bloc/login_event.dart';
import 'package:notificationapp/login/bloc/login_state.dart';
import 'package:notificationapp/login/model/models.dart';
import 'package:notificationapp/login/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final Logger logger = Logger();

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<SignInUser>(_onSignInUser);
    
    on<CheckTokenExpiry>(_onCheckTokenExpiry);
  }
  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    logger.i('Creating user: ${event.email}'); 

    try {
      final createdUser =
          await userRepository.createUser(event.email, event.password);

      emit(UserCreated(createdUser));

      logger.i('User created successfully: ${createdUser.id}');
    } catch (error) {
      logger.e('Error creating user: $error');
      emit(UserError(error.toString()));
    }
  }


  Future<void> _onSignInUser(SignInUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final authResponse = await userRepository.signIn(event.email, event.password);

      emit(UserAuthenticated(authResponse.token));
      logger.i("User authenticated successfully with token: ${authResponse.token}");
    } catch (e) {
      emit(UserError(e.toString()));
      logger.e("Error signing in user: ${e.toString()}");
    }
  }

  



  
  Future<void> _onCheckTokenExpiry(CheckTokenExpiry event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryDateString = prefs.getString('expiryDate');

    if (expiryDateString != null) {
      final expiryDate = DateTime.parse(expiryDateString);
      if (DateTime.now().isAfter(expiryDate)) {
        emit(TokenExpired());
        logger.i("Token expired, session ended");
      }
    }
  }
}

