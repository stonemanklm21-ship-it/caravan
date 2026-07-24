import 'dart:math';

import '../models/character.dart';
import '../models/skill.dart';

class SkillService {
  static double asymptoticValue({
    required double skill,
    required double start,
    required double end,
    double halfLife = 100,
  }) {
    return end +
        (start - end) *
            pow(
              0.5,
              skill / halfLife,
            );
  }

  static double getXp(
    Character character,
    Skill skill,
  ) {
    switch (skill) {
      case Skill.doctor:
        return character.doctorXp;
      case Skill.vet:
        return character.vetXp;
      case Skill.mechanic:
        return character.mechanicXp;
      case Skill.scout:
        return character.scoutXp;
      case Skill.combat:
        return character.combatXp;
    }
  }

  static void addXp(
    Character character,
    Skill skill,
    double amount,
  ) {
    if (amount <= 0) {
      return;
    }

    switch (skill) {
      case Skill.doctor:
        character.doctorXp += amount;
        break;
      case Skill.vet:
        character.vetXp += amount;
        break;
case Skill.mechanic:
  character.mechanicXp += amount;
  break;
      case Skill.scout:
        character.scoutXp += amount;
        break;
      case Skill.combat:
        character.combatXp += amount;
        break;
    }
  }

  static void addSharedXp({
    required List<Character> characters,
    required Skill skill,
    required double amount,
  }) {
    if (amount <= 0) {
      return;
    }

    final skilledCharacters =
        characters
            .where(
              (character) =>
                  getLevel(
                    character,
                    skill,
                  ) >
                  0,
            )
            .toList();

    if (skilledCharacters.isEmpty) {
      return;
    }

    final totalSkill =
        skilledCharacters.fold<int>(
      0,
      (total, character) =>
          total +
          getLevel(
            character,
            skill,
          ),
    );

    if (totalSkill <= 0) {
      return;
    }

    for (final character
        in skilledCharacters) {
      final skillLevel =
          getLevel(
        character,
        skill,
      );

      final share =
          skillLevel / totalSkill;

      addXp(
        character,
        skill,
        amount * share,
      );
    }
  }

  static int levelForXp(
    double xp,
  ) {
    return sqrt(max(0, xp)).floor();
  }

  static double xpForLevel(
    int level,
  ) {
    return (level * level).toDouble();
  }

  static double xpToNextLevel(
    Character character,
    Skill skill,
  ) {
    final level = getLevel(
      character,
      skill,
    );

    return xpForLevel(level + 1) -
        getXp(character, skill);
  }

  static double progressToNextLevel(
    Character character,
    Skill skill,
  ) {
    final xp = getXp(
      character,
      skill,
    );

    final level = levelForXp(xp);

    final levelXp =
        xpForLevel(level);

    final nextLevelXp =
        xpForLevel(level + 1);

    final range =
        nextLevelXp - levelXp;

    if (range <= 0) {
      return 1;
    }

    return ((xp - levelXp) / range)
        .clamp(0.0, 1.0);
  }

  static int getLevel(
    Character character,
    Skill skill,
  ) {
    return levelForXp(
      getXp(character, skill),
    );
  }
}