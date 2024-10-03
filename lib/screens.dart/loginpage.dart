import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginpage extends StatelessWidget {
  const loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A345B),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 580),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "assets/snows.png",
                ),
              )),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 110, top: 40),
                child: Text(
                  'Todo',
                  style: TextStyle(
                      color: Color(0xFFC2C8D4),
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 190, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    'Enter Mail',
                    style: TextStyle(color: Color(0xFFFFF8F8), fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          focusColor: Color.fromARGB(135, 33, 149, 243),
                          fillColor: Color.fromARGB(135, 33, 149, 243),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromARGB(135, 33, 149, 243)),
                          )),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 7),
                  child: Text(
                    'Enter password',
                    style: TextStyle(color: Color(0xFFFFF8F8), fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 58,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          focusColor: Color.fromARGB(135, 33, 149, 243),
                          fillColor: Color.fromARGB(135, 33, 149, 243),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide(
                                color: Color.fromARGB(135, 33, 149, 243)),
                          )),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                      height: 50,
                      width: 110,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(135, 33, 149, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {},
                          child: Text(
                            'Login',
                            style: TextStyle(color: Color(0xFFFFF8F8)),
                          ))),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
