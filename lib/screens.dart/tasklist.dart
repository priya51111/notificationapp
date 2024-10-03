import 'package:flutter/material.dart';

class tasklist extends StatefulWidget {
  const tasklist({super.key});

  @override
  State<tasklist> createState() => _tasklistState();
}

class _tasklistState extends State<tasklist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0), // Set your preferred height here
        child: Padding(
          padding: const EdgeInsets.only(
            top: 35,
          ),
          child: AppBar(
            backgroundColor: Color.fromARGB(135, 33, 149, 243),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 45,
                    bottom: 25,
                  ),
                  child: Text(
                    "Task Lists",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
