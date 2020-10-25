import 'dart:ui';

import 'package:agenda_contatos/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        
        primarySwatch: Colors.teal,accentColor: Colors.tealAccent,
        fontFamily: "Raleway"),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
