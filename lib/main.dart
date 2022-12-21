import 'package:flutter/material.dart';
import 'package:practical_exam/homepage.dart';

void main(){
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}