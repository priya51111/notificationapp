import 'package:bloc/bloc.dart';
import 'package:notificationapp/login/bloc/login_event.dart';
import 'package:notificationapp/login/bloc/login_state.dart';
import 'package:notificationapp/login/repository/repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<CreateUser>(_onCreateUser);
    on<SignInUser>(_onSignInUser);
    on<SignOutUser>(_onSignOutUser);
    on<CheckTokenExpiry>(_onCheckTokenExpiry);
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      await userRepository.createUser(event.mailId, event.password);
      emit(UserCreated());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSignInUser(SignInUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final authResponse = await userRepository.signIn(event.mailId, event.password);
      emit(UserAuthenticated(authResponse));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSignOutUser(SignOutUser event, Emitter<UserState> emit) async {
    await userRepository.signOut();
    emit(UserSignOut());
  }

  Future<void> _onCheckTokenExpiry(CheckTokenExpiry event, Emitter<UserState> emit) async {
    final isExpired = await userRepository.isTokenExpired();
    if (isExpired) {
      emit(TokenExpired());
    }
  }
}
