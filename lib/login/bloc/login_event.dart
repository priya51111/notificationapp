abstract class UserEvent {}

class CreateUser extends UserEvent {
  final String mailId;
  final String password;

  CreateUser({required this.mailId, required this.password});
}

class SignInUser extends UserEvent {
  final String mailId;
  final String password;

  SignInUser({required this.mailId, required this.password});
}

class SignOutUser extends UserEvent {}

class CheckTokenExpiry extends UserEvent {}
