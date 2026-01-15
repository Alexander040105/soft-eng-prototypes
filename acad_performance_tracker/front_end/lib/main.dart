import 'package:flutter/material.dart';
import 'pages/students_pages/register_student.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const RegisterStudentWidget(),
      routes: {
        '/home': (context) => RegisterStudentWidget(),
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          titleSpacing: 50,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        scaffoldBackgroundColor:Colors.transparent,
        drawerTheme: DrawerThemeData(
          backgroundColor: Color(0xFF700626),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 172, 10, 58),
          )
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}