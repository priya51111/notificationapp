import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskSubmitted extends TaskEvent {
  final String task;
  final String date;
  final String time;

  TaskSubmitted({required this.task, required this.date, required this.time});

  @override
  List<Object> get props => [task, date, time];
}

class FetchTaskEvent extends TaskEvent {
  final String userId;
  final String date;
  FetchTaskEvent({required this.userId, required this.date});
  @override
  List<Object> get props => [userId, date];
}
