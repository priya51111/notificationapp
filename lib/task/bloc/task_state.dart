import 'package:equatable/equatable.dart';

import '../model.dart';


abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskSuccess extends TaskState {
  final List<Task> tasks;

  const TaskSuccess({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskDeleted extends TaskState {
  final String taskId;

  TaskDeleted({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure({required this.message} );
  @override
  List<Object> get props => [message];
}
