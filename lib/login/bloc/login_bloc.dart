import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:notificationapp/login/bloc/login_event.dart';
import 'package:notificationapp/login/bloc/login_state.dart';
import 'package:notificationapp/login/model/models.dart';
import 'package:notificationapp/login/repository/repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final Logger logger = Logger();

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<SignInUser>(_onSignInUser);
    on<SignOutUser>(_onSignOutUser);
    on<CheckTokenExpiry>(_onCheckTokenExpiry);
  }
Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
  try {
    emit(UserLoading());
    final User createResponse = await userRepository.createUser(event.mailId, event.password);
    emit(UserCreated(createResponse));  
    logger.i("User created successfully: ${createResponse.userId}");
  } catch (e) {
    emit(UserError(e.toString()));
    logger.e("Error creating user: ${e.toString()}");
  }
}


  Future<void> _onSignInUser(SignInUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final authResponse = await userRepository.signIn(event.mailId, event.password);
      emit(UserAuthenticated(authResponse));
      logger.i("User authenticated");
    } catch (e) {
      emit(UserError(e.toString()));
      logger.e("Error signing in user: ${e.toString()}");
    }
  }

  Future<void> _onSignOutUser(SignOutUser event, Emitter<UserState> emit) async {
    await userRepository.signOut();
    emit(UserSignOut());
    logger.i("User signed out");
  }

  Future<void> _onCheckTokenExpiry(CheckTokenExpiry event, Emitter<UserState> emit) async {
    final isExpired = await userRepository.isTokenExpired();
    if (isExpired) {
      emit(TokenExpired());
      logger.i("Token expired, session ended");
    }
  }
}
