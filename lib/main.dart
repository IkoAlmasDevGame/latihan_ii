import 'package:flutter/material.dart';
import 'package:latihan_ii/ui/SignIn/Login.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Latihan Database II",
      home: LoginHome(),
    );
  }
}
