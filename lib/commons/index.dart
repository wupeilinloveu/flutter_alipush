import 'package:flutter/material.dart';

final List<String> tabTitle = ["Home", "Setting"];

dynamic pages = [
  {
    "icon": Icon(Icons.home),
    "icon2": Icon(Icons.home, color: Colors.blue),
    "title": Text("Home"),
    "title2": Text("Home"),
//    "type": MainScreenType.HOME
  },
  {
    "icon": Icon(Icons.settings),
    "icon2": Icon(Icons.settings,  color: Colors.blue),
    "title": Text("Setting"),
    "title2": Text("Setting"),
//    "type": MainScreenType.SETTING
  },
];
