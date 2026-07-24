import 'package:flutter/material.dart';

class PortraitDna {
  static const int currentVersion = 2;

  final int? headStyle;
  final int? hairStyle;
  final int? eyeStyle;
  final int? mouthStyle;

  final String? headAssetOverride;
  final String? hairAssetOverride;
  final String? eyeAssetOverride;
  final String? mouthAssetOverride;

  /// Additional layers rendered on top of the portrait.
  ///
  /// Examples:
  /// - hood
  /// - crown
  /// - eyepatch
  /// - scar
  /// - face paint
  /// - noble jewellery
  final List<String> extraLayers;

  final Color skinColor;
  final Color hairColor;
  final Color mouthColor;

  const PortraitDna({
    this.headStyle,
    this.hairStyle,
    this.eyeStyle,
    this.mouthStyle,
    this.headAssetOverride,
    this.hairAssetOverride,
    this.eyeAssetOverride,
    this.mouthAssetOverride,
    this.extraLayers = const [],
    required this.skinColor,
    required this.hairColor,
    required this.mouthColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': currentVersion,
      'headStyle': headStyle,
      'hairStyle': hairStyle,
      'eyeStyle': eyeStyle,
      'mouthStyle': mouthStyle,
      'headAssetOverride': headAssetOverride,
      'hairAssetOverride': hairAssetOverride,
      'eyeAssetOverride': eyeAssetOverride,
      'mouthAssetOverride': mouthAssetOverride,
      'extraLayers': extraLayers,
      'skinColor': skinColor.toARGB32(),
      'hairColor': hairColor.toARGB32(),
      'mouthColor': mouthColor.toARGB32(),
    };
  }

  factory PortraitDna.fromJson(
    Map<String, dynamic> json,
  ) {
    final version =
        json['version'] as int? ?? 1;

    switch (version) {
      case 1:
      case 2:
        return PortraitDna(
          headStyle: json['headStyle'] as int?,
          hairStyle: json['hairStyle'] as int?,
          eyeStyle: json['eyeStyle'] as int?,
          mouthStyle: json['mouthStyle'] as int?,

          headAssetOverride:
              json['headAssetOverride']
                  as String?,

          hairAssetOverride:
              json['hairAssetOverride']
                  as String?,

          eyeAssetOverride:
              json['eyeAssetOverride']
                  as String?,

          mouthAssetOverride:
              json['mouthAssetOverride']
                  as String?,

          extraLayers:
              (json['extraLayers']
                          as List?)
                      ?.cast<String>() ??
                  const [],

          skinColor: Color(
            json['skinColor'] as int,
          ),

          hairColor: Color(
            json['hairColor'] as int,
          ),

          mouthColor: Color(
            json['mouthColor'] as int,
          ),
        );

      default:
        throw UnsupportedError(
          'Unsupported PortraitDna version: '
          '$version',
        );
    }
  }

  PortraitDna copyWith({
    int? headStyle,
    int? hairStyle,
    int? eyeStyle,
    int? mouthStyle,
    String? headAssetOverride,
    String? hairAssetOverride,
    String? eyeAssetOverride,
    String? mouthAssetOverride,
    List<String>? extraLayers,
    Color? skinColor,
    Color? hairColor,
    Color? mouthColor,
  }) {
    return PortraitDna(
      headStyle: headStyle ?? this.headStyle,
      hairStyle: hairStyle ?? this.hairStyle,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      mouthStyle: mouthStyle ?? this.mouthStyle,

      headAssetOverride:
          headAssetOverride ??
          this.headAssetOverride,

      hairAssetOverride:
          hairAssetOverride ??
          this.hairAssetOverride,

      eyeAssetOverride:
          eyeAssetOverride ??
          this.eyeAssetOverride,

      mouthAssetOverride:
          mouthAssetOverride ??
          this.mouthAssetOverride,

      extraLayers:
          extraLayers ?? this.extraLayers,

      skinColor: skinColor ?? this.skinColor,
      hairColor: hairColor ?? this.hairColor,
      mouthColor:
          mouthColor ?? this.mouthColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PortraitDna &&
            headStyle == other.headStyle &&
            hairStyle == other.hairStyle &&
            eyeStyle == other.eyeStyle &&
            mouthStyle == other.mouthStyle &&
            headAssetOverride ==
                other.headAssetOverride &&
            hairAssetOverride ==
                other.hairAssetOverride &&
            eyeAssetOverride ==
                other.eyeAssetOverride &&
            mouthAssetOverride ==
                other.mouthAssetOverride &&
            skinColor == other.skinColor &&
            hairColor == other.hairColor &&
            mouthColor == other.mouthColor &&
            _listEquals(
              extraLayers,
              other.extraLayers,
            );
  }

  @override
  int get hashCode => Object.hash(
        headStyle,
        hairStyle,
        eyeStyle,
        mouthStyle,
        headAssetOverride,
        hairAssetOverride,
        eyeAssetOverride,
        mouthAssetOverride,
        Object.hashAll(extraLayers),
        skinColor,
        hairColor,
        mouthColor,
      );

  static bool _listEquals<T>(
    List<T> a,
    List<T> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    return 'PortraitDna('
        'headStyle: $headStyle, '
        'hairStyle: $hairStyle, '
        'eyeStyle: $eyeStyle, '
        'mouthStyle: $mouthStyle, '
        'extraLayers: ${extraLayers.length}'
        ')';
  }
}
