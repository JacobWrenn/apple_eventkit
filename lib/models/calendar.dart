import 'package:flutter/material.dart';

class Calendar {
  String title;
  String id;
  bool editable;
  Color color;
  String account;

  Calendar(this.title, this.id, this.editable, this.color, this.account);

  static Color parseColor(String color) {
    final split = color.split(":");
    final red = (double.parse(split[0]) * 255).round();
    final green = (double.parse(split[1]) * 255).round();
    final blue = (double.parse(split[2]) * 255).round();
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Calendar.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        editable = json['editable'],
        color = parseColor(json['color']),
        account = json['account'];
}
