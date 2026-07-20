import 'package:flutter/material.dart';

import 'portrait_generator.dart';

class CharacterPortrait extends StatelessWidget {
  final int seed;
  final double size;

  const CharacterPortrait({
    super.key,
    required this.seed,
    this.size = 192,
  });

  @override
  Widget build(BuildContext context) {
    final dna = PortraitGenerator.generate(seed);

    final headAsset = switch (dna.headStyle) {
      0 => 'assets/head1.png',
      1 => 'assets/head2.png',
      _ => 'assets/head3.png',
    };

    final hairAsset = switch (dna.hairStyle) {
      0 => 'assets/hair1.png',
      1 => 'assets/hair2.png',
      2 => 'assets/hair3.png',
      3 => 'assets/hair4.png',
      4 => 'assets/hair5.png',
      5 => 'assets/hair6.png',
      6 => 'assets/hair7.png',
      7 => 'assets/hair8.png',
      8 => 'assets/hair9.png',
      _ => 'assets/hair10.png',
    };

    final eyesAsset = switch (dna.eyeStyle) {
      0 => 'assets/eye1.png',
      1 => 'assets/eye2.png',
      2 => 'assets/eye3.png',
      3 => 'assets/eye4.png',
      4 => 'assets/eye5.png',
      _ => 'assets/eye6.png',
    };

    final mouthAsset = switch (dna.mouthStyle) {
      0 => 'assets/mouth1.png',
      1 => 'assets/mouth2.png',
      2 => 'assets/mouth3.png',
      _ => 'assets/mouth4.png',
    };

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              dna.skinColor,
              BlendMode.modulate,
            ),
            child: Image.asset(
              headAsset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
            ),
          ),

          Image.asset(
            eyesAsset,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none,
          ),

          ColorFiltered(
            colorFilter: ColorFilter.mode(
              dna.mouthColor,
              BlendMode.modulate,
            ),
            child: Image.asset(
              mouthAsset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
            ),
          ),

          ColorFiltered(
            colorFilter: ColorFilter.mode(
              dna.hairColor,
              BlendMode.modulate,
            ),
            child: Image.asset(
              hairAsset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
            ),
          ),
        ],
      ),
    );
  }
}