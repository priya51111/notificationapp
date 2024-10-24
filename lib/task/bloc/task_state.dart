import 'package:equatable/equatable.dart';

import '../models.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskCreated extends TaskState {
  final Tasks task;
  const TaskCreated({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskSuccess extends TaskState {
  final List<Tasks> taskList;
  final Map<String, String> menuMap; // Map menuId to menuName

  TaskSuccess({required this.taskList, required this.menuMap});
}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure({required this.message});
  @override
  List<Object> get props => [message];
}
