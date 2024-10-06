import 'package:notificationapp/login/model/models.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserCreated extends UserState {
  final User createResponse; // You can replace `dynamic` with the actual type

  UserCreated(this.createResponse);
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
