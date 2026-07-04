import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';

class SaveService {
  static const String saveKey =
      'merchant_caravan_save';

  static Future<void> save(
    Game game,
  ) async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final jsonString =
        jsonEncode(
      game.toJson(),
    );

    await prefs.setString(
      saveKey,
      jsonString,
    );
  }

  static Future<Game?> load() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    final jsonString =
        prefs.getString(saveKey);

    if (jsonString == null) {
      return null;
    }

    final json =
        jsonDecode(jsonString)
            as Map<String, dynamic>;

    return Game.fromJson(json);
  }
}