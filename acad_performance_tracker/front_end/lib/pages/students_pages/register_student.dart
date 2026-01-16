import 'package:flutter/material.dart';

class RegisterStudentWidget extends StatefulWidget {
  const RegisterStudentWidget({super.key});

  @override
  State<RegisterStudentWidget> createState() => _RegisterStudentWidgetState();
}

class _RegisterStudentWidgetState extends State<RegisterStudentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF700626),
              Color(0xFF300003),
            ],
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Student Page'),
            ),
            body: Center(
                child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to the Student Home Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Student ID
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Enter your Student ID')),
                  //Full Name
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Enter your Full Name')),
                  //School Email
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Enter your School Email')),
                  //Year
                  TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Enter your School Email'))
                ],
              ),
            ))));
  }
}
