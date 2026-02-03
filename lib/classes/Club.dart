import 'package:flutter/material.dart';

class Club {
  final String name;
  final Color color;

  Club({required this.name, required this.color});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Club &&
            runtimeType == other.runtimeType &&
            name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
