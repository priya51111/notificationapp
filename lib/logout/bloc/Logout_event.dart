import 'package:equatable/equatable.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class LogoutRequested extends LogoutEvent {
  final String userId;
  final String token;

  const LogoutRequested({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}
