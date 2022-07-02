import 'package:flutter/material.dart';
import 'package:hackaton_fiap_mobile/login.dart';
import 'form.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

void main(List<String> arguments)  async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackaton FIAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark
      ),
      initialRoute: LoginScreen.id,
      routes: {
        MyFormPage.id: (context) => MyFormPage(),
        LoginScreen.id: (context) => const LoginScreen()
      },
    );
  }
}