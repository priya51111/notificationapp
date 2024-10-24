import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../login/repository/repository.dart';
import '../task/bloc/task_bloc.dart';
import '../task/bloc/task_event.dart';
import '../task/bloc/task_state.dart';
import '../task/repository/task_repository.dart';
import '../task/view/view.dart';
import 'bloc/menu_bloc.dart';
import 'bloc/menu_event.dart';
import 'bloc/menu_state.dart';
import 'repo/menu_repository.dart';

enum Menu {
  TaskLists,
  AddInBatchMode,
  RemoveAds,
  MoreApps,
  SendFeedback,
  FollowUs,
  Invite,
  Settings
}

class SimplePage extends StatefulWidget {
  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> {
  String? dropdownValue;
  List<String> dropdownItems = ['New List'];
  late UserRepository userRepository;
  late MenuRepository menuRepository;
  late TaskRepository taskRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(); // Initialize the user repository
    menuRepository = MenuRepository(
        userRepository:
            userRepository); // Pass user repository to menu repository
    taskRepository = TaskRepository(
      userRepository: userRepository,
      menuRepository: menuRepository,
    ); // Pass both repositories to task repositoryn

    _fetchMenus();
    _fetchTasks();
  }

  void _fetchMenus() {
    final userId = userRepository.getUserId();
    final date = menuRepository.getdate();

    if (userId != null) {
      context.read<MenuBloc>().add(FetchMenusEvent(userId: userId, date: date));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User ID is missing'),
            duration: Duration(seconds: 5)),
      );
    }
  }

  void _fetchTasks() {
    final userIds = userRepository.getUserId();
    final dates = taskRepository.date();

    if (userIds != null) {
      context
          .read<TaskBloc>()
          .add(FetchTaskEvent(userId: userIds, date: dates));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('User IDs is missing'),
            duration: Duration(seconds: 5)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 33, 149, 243),
        title: Row(
          children: [
            Icon(Icons.check_circle, size: 30),
            DropdownButton<String>(
              value: dropdownValue,
              hint: Text('Select'),
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value == 'New List') {
                  _showNewMenuDialog();
                } else {
                  setState(() {
                    dropdownValue = value;
                  });
                }
              },
            ),
            BlocListener<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state is MenuCreated) {
                  setState(() {
                    if (!dropdownItems.contains(state.menuname)) {
                      dropdownItems
                          .add(state.menuname); // Add the newly created menu
                    }
                    dropdownValue = state.menuname; // Set as selected
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Menu created successfully: ${state.menuId}'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (state is MenuError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else if (state is MenuLoaded) {
                  setState(() {
                    dropdownItems = [
                      'New List',
                      ...state.menuList.map((menu) => menu.menuname).toList()
                    ];
                    dropdownValue = dropdownItems.first;
                  });
                }
              },
              child: SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          _buildPopupMenu()
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskSuccess) {
            return ListView.builder(
              itemCount: state.taskList.length,
              itemBuilder: (context, index) {
                final task = state.taskList[index];
                 final menuname = state.menuMap[task.menuId] ?? 'Unknown menu'; // Fetch the menu name
                return Padding(
                  padding: const EdgeInsets.all(9),
                  child: Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(135, 33, 149, 243),
                    ),
                    child: Column(
                      children: [
                        Text(task.task), // Display task name
                        SizedBox(width: 10),
                        Text(
                            '${task.date} ${task.time}'), // Display date and time
                        SizedBox(width: 10),
                        // Handle the list of menuIds
                         SizedBox(width: 10),
                  Text(menuname), // Display menu name based on menuId
                      ],
                    ),  
                  ),
                );
              },
            );
          } else if (state is TaskFailure) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No tasks available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<Menu>(
      elevation: 0,
      color: Color.fromARGB(135, 33, 149, 243),
      constraints: BoxConstraints.tightFor(height: 410, width: 200),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (Menu item) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.TaskLists,
          child: Text('Task Lists',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.AddInBatchMode,
          child: Text('Add in Batch Mode',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.RemoveAds,
          child: Text('Remove Ads',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.MoreApps,
          child: Text('More Apps',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.SendFeedback,
          child: Text('Send Feedback',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.FollowUs,
          child: Text('Follow Us',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.Settings,
          child: Text('Settings',
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ],
    );
  }

  void _showNewMenuDialog() {
    final TextEditingController menuController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Menu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: menuController,
                decoration: InputDecoration(hintText: 'Menu Name'),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(hintText: 'Select Date'),
                onTap: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate!);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String menuName = menuController.text.trim();
                final String date = dateController.text.trim();
                if (menuName.isNotEmpty && date.isNotEmpty) {
                  // Trigger the event to create a new menu
                  context
                      .read<MenuBloc>()
                      .add(CreateMenuEvent(menuname: menuName, date: date));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please fill in all fields'),
                        duration: Duration(seconds: 3)),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
