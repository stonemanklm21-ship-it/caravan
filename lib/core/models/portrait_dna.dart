import 'package:flutter/material.dart';

class PortraitDna {
  final int headStyle;
  final int hairStyle;
  final int mouthStyle;
  final Color mouthColor;
  final Color skinColor;
  final Color hairColor;
  final int eyeStyle;

  const PortraitDna({
    required this.headStyle,
    required this.hairStyle,
    required this.eyeStyle,
    required this.mouthStyle,
    required this.mouthColor,
    required this.skinColor,
    required this.hairColor,
  });
}