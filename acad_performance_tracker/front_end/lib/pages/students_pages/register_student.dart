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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF700626),
            const Color(0xFF300003),
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
                Text(
                  'Welcome to the Student Home Page',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //Student ID
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter your Student ID')
                ),
                //Full Name
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter your Full Name')
                ),
                //School Email
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter your School Email')
                )
                
              ],
            ),
          )
        )
      )
    );
  }
}