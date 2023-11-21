import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mycolor{
  final Shader _linearGradient =  LinearGradient(
    colors: [Colors.red, Colors.purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 350, 0.0));
}

