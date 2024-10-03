import 'package:flutter/material.dart';

const List<String> list = <String>[
  'All List',
  'Personal',
  'Shopping',
  'work',
  "finished",
  "default",
  "New List",
  "Finished"
];
bool isChecked = false;

enum menu {
  TaskLists,
  AddINBatchMode,
  RemoveAds,
  Moreapps,
  SendFeedback,
  followus,
  invite,
  setting
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(135, 33, 149, 243),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              value: dropdownValue,
              underline: Container(
                color: Color.fromARGB(134, 4, 83, 147),
              ),
              dropdownColor: Color.fromARGB(134, 4, 83, 147),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 60),
                        child: Center(child: Text(value)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              PopupMenuButton<menu>(
                elevation: 0,
                color: Color.fromARGB(135, 33, 149, 243),
                constraints: BoxConstraints.tightFor(height: 410, width: 200),
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (menu item) {},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<menu>>[
                  const PopupMenuItem<menu>(
                    value: menu.TaskLists,
                    child: Text('Task Lists',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.AddINBatchMode,
                    child: Text('Add in Batch Mode',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.RemoveAds,
                    child: Text('Remove Ads',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.Moreapps,
                    child: Text('More Apps',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.SendFeedback,
                    child: Text('Send Feedback',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.followus,
                    child: Text('Follow us',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.followus,
                    child: Text('Follow us',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                  const PopupMenuItem<menu>(
                    value: menu.setting,
                    child: Text('Settings',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: 70,
                width: 370,
                decoration: BoxDecoration(
                  color: Color.fromARGB(135, 33, 149, 243),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  leading: Checkbox(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  title: Text(
                    'Taskname',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      Text('day,', style: TextStyle(color: Colors.white)),
                      Text('date,', style: TextStyle(color: Colors.white)),
                      Text('year,', style: TextStyle(color: Colors.white)),
                      Text('time', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
