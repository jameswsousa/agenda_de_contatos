import 'package:agenda_contatos/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.teal,
      accentColor: Colors.tealAccent
    ),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
