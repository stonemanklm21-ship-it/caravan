import 'dart:math';

import 'package:flutter/material.dart';

import '../models/portrait_dna.dart';

class PortraitGenerator {
  static PortraitDna generate(int seed) {
    final rng = Random(seed);

    const skinTones = [
      Color(0xFFFFE0BD), // very light
      Color(0xFFF1C27D), // light
      Color(0xFFE0AC69), // tan
      Color(0xFFC68642), // medium brown
      Color(0xFF8D5524), // dark brown
      Color(0xFF5C3A21), // very dark brown
    ];

    const hairColours = [
      Colors.black,
      Color(0xFF2C1B18), // dark brown
      Color(0xFF5C4033), // brown
      Color(0xFF8B5A2B), // chestnut
      Color(0xFFD6B370), // blonde
      Color(0xFFF3E5AB), // light blonde
      Color(0xFFB7410E), // auburn
      Color(0xFFD2691E), // ginger
      Colors.grey,
      Color(0xFFE0E0E0), // silver
      Color(0xFFFFFFFF), // white
    ];

    const mouthColours = [
      Color(0xFF7A403D), // dark rose
      Color(0xFF8D4A46), // muted red-brown
      Color(0xFFA35C58), // dusty rose
      Color(0xFFB96E69), // soft lip pink
      Color(0xFFCD807A), // warm pink
      Color(0xFFE0948D), // lighter pink
    ];

    return PortraitDna(
      headStyle: rng.nextInt(3),
      hairStyle: rng.nextInt(10),
      eyeStyle: rng.nextInt(6),
      mouthStyle: rng.nextInt(4),
      skinColor:
          skinTones[rng.nextInt(skinTones.length)],
      hairColor:
          hairColours[rng.nextInt(hairColours.length)],
      mouthColor:
          mouthColours[rng.nextInt(mouthColours.length)],
    );
  }
}