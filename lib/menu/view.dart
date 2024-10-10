import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../task/bloc/task_bloc.dart';
import '../task/bloc/task_event.dart';
import '../task/bloc/task_state.dart';
import '../task/model.dart';
import '../task/view/view.dart';
import 'bloc/menu_bloc.dart';
import 'bloc/menu_event.dart';
import 'bloc/menu_state.dart';
import 'model.dart';

class TaskMenuPage extends StatefulWidget {
  final String? userId;

  TaskMenuPage({this.userId});

  @override
  _TaskMenuPageState createState() => _TaskMenuPageState();
}

class _TaskMenuPageState extends State<TaskMenuPage> {
  String? dropdownValue;
  bool _isDateSelected = false;
  final TextEditingController _dateController = TextEditingController();
  bool isTaskSelected = false;
  Task? selectedTask;
  bool canCreateTask = false; // Tracks if the task can be created after New List is selected

  @override
  void initState() {
    super.initState();
    // If userId is not provided, retrieve from storage
    final storedUserId = widget.userId ?? GetStorage().read('userId');
    if (storedUserId != null) {
      context.read<TaskBloc>().add(FetchTasksByUserId(userId: storedUserId));
    } else {
      // Handle the case where userId is not available
      // For example, show an error or navigate back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isTaskSelected
            ? Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Implement share functionality here if needed
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (selectedTask != null && selectedTask!.taskId != null) {
                        context.read<TaskBloc>().add(DeleteTaskEvent(
                            taskId: selectedTask?.taskId ?? 'default_value'));
                        setState(() {
                          isTaskSelected = false;
                          selectedTask = null;
                        });
                      } else {
                        print('No task is selected or taskId is null');
                      }
                    },
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(Icons.check_circle, size: 30),
                  SizedBox(width: 10),
                  BlocBuilder<MenuBloc, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoading) {
                        return CircularProgressIndicator();
                      } else if (state is MenuLoaded) {
                        final menuList = state.menuList;
                        return DropdownButton<String>(
                          value: dropdownValue,
                          items: [
                            ...menuList.map((Menus menu) {
                              return DropdownMenuItem<String>(
                                value: menu.menuId,
                                child: Text(menu.menuName),
                              );
                            }).toList(),
                            DropdownMenuItem<String>(
                              value: "New List",
                              child: Text("New List"),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value == "New List") {
                              _showAddMenuDialog(context);
                            } else {
                              setState(() {
                                dropdownValue = value;
                                canCreateTask = false; // Task creation only after "New List"
                              });
                            }
                          },
                        );
                      } else if (state is MenuError) {
                        return Text('Error: ${state.message}');
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskSuccess) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/noimage.png',
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No tasks available',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  final taskDueDate = DateTime.parse(task.date);
                  bool isExpired = DateTime.now().isAfter(taskDueDate);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        isTaskSelected = true;
                        selectedTask = task;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.only(
                          left: task.isChecked ? 100 : 10, top: 10),
                      child: task.isChecked
                          ? SizedBox.shrink()
                          : Container(
                              height: 70,
                              width: 370,
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? Colors.red
                                    : Color.fromARGB(135, 33, 149, 243),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  side: BorderSide(
                                    color: Colors.white,
                                  ),
                                  value: task.isChecked,
                                  onChanged: (bool? value) {
                                    if (value != null && value) {
                                      context.read<TaskBloc>().add(
                                          UpdateTaskStatus(
                                              task: task.copyWith(
                                                  isChecked: value)));
                                      _showTaskFinishedDialog(context);
                                    }
                                  },
                                ),
                                title: Text(
                                  task.task,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      isExpired ? 'No due' : '${task.date},',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    if (!isExpired)
                                      Text(
                                        ' ${task.time}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  );
                },
              );
            }
          } else if (state is TaskFailure) {
            return Center(
                child: Text('Failed to load tasks: ${state.message}'));
          } else {
            return Center(child: Text('No tasks available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: canCreateTask
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTaskPage()),
                );
              }
            : null, // Disable the button until "New List" is selected
        child: const Icon(Icons.add),
        backgroundColor:
            canCreateTask ? Colors.blue : Colors.grey, // Change button color
      ),
    );
  }

  void _showAddMenuDialog(BuildContext context) {
    final TextEditingController menuController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Menu Name'),
          content: Column(
            children: [
              TextField(
                controller: menuController,
                decoration: InputDecoration(hintText: 'Menu Name'),
              ),
              Text(
                "Due Date",
                style: TextStyle(
                  color: Color.fromARGB(135, 33, 149, 243),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _dateController,
                style: TextStyle(color: Colors.white),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.blue.shade900,
                            onPrimary: Colors.white,
                            onSurface: Colors.blue.shade900,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    setState(() {
                      _isDateSelected = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Date not set",
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final menuName = menuController.text;
                final date = _dateController.text;
                if (menuName.isNotEmpty) {
                  context.read<MenuBloc>().add(
                        CreateMenuEvent(menuName: menuName, date: date),
                      );
                  Navigator.of(context).pop();
                }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskFinishedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Task Finished'),
          content: Text('The task has been marked as completed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
} 

