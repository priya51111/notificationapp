import 'package:notificationapp/login/model/models.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserCreated extends UserState {
 final User user;

  UserCreated(this.user);
}

class UserAuthenticated extends UserState {
  final String token;

  UserAuthenticated(this.token);
}

class UserSignOut extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class TokenExpired extends UserState {}



