import 'package:notificationapp/login/model/models.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserCreated extends UserState {
 final User user; // Pass the created user to the state

  UserCreated(this.user);
}

class UserAuthenticated extends UserState {
  final AuthResponse authResponse;

  UserAuthenticated(this.authResponse);
}

class UserSignOut extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class TokenExpired extends UserState {}
