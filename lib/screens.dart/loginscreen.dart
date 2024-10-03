import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isObscure = false;
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A345B),
      body: Form(
        key: _formkey,
        child: Column(children: [
          Row(children: [
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
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 13, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7, right: 305),
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
                    padding:
                        const EdgeInsets.only(top: 15, left: 7, right: 260),
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
                        obscureText: isObscure ?? true,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter valid password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color.fromRGBO(117, 117, 117, 1),
                                  size: 24,
                                )),
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
                  )),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 135,
                      left: 0,
                      right: 0,
                    ),
                    child: Image(image: AssetImage('assets/snows.png')),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
