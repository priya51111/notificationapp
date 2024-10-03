import 'package:flutter/material.dart';

class batch extends StatefulWidget {
  const batch({super.key});

  @override
  State<batch> createState() => _batchState();
}

class _batchState extends State<batch> {
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
                    "Add in Batch Mode",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What is to be done?",
              style: TextStyle(
                  color: Color.fromARGB(233, 116, 200, 245),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 380,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusColor: Color.fromARGB(135, 33, 149, 243),
                    fillColor: Color.fromARGB(135, 33, 149, 243),
                    hintText: "Task1\nTask2\nTask3\netc.",
                    hintStyle: TextStyle(color: Colors.grey)),
                maxLines: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Duedate",
                style: TextStyle(
                    color: Color.fromARGB(233, 116, 200, 245),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 380,
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusColor: Color.fromARGB(233, 116, 200, 245),
                    fillColor: Color.fromARGB(233, 116, 200, 245),
                    hintText: "Date not set",
                    hintStyle: TextStyle(color: Colors.grey)),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
