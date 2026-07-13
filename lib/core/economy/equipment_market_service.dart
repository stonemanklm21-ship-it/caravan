import 'dart:math';

import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';
import '../../data/weapon_data.dart';

import '../models/armour.dart';
import '../models/city.dart';
import '../models/helmet.dart';
import '../models/weapon.dart';

enum EquipmentMarketTier {
  basic,
  regional,
  major,
}

class EquipmentMarketService {
  static final Random _random =
      Random();

  static void refreshMarket({
    required City city,
    required int currentHour,
    int stockSize = 8,
  }) {
    final tier =
        city.equipmentMarketTier;

    if (tier == null) {
      return;
    }

    final hoursSinceRefresh =
        currentHour -
        city
            .lastEquipmentMarketRefreshHour;

    if (city.weaponMarketStock
            .isEmpty ||
        city.armourMarketStock
            .isEmpty ||
        city.helmetMarketStock
            .isEmpty ||
        hoursSinceRefresh >= 72) {
      city.weaponMarketStock =
          generateWeaponStock(
        tier: tier,
        stockSize: stockSize,
      );

      city.armourMarketStock =
          generateArmourStock(
        tier: tier,
        stockSize: stockSize,
      );

      city.helmetMarketStock =
          generateHelmetStock(
        tier: tier,
        stockSize: stockSize,
      );

      city
          .lastEquipmentMarketRefreshHour =
          currentHour;
    }
  }

  static List<Weapon>
      availableWeapons(
    EquipmentMarketTier tier,
  ) {
    switch (tier) {
      case EquipmentMarketTier.basic:
        return [
          knife,
          club,
        ];

      case EquipmentMarketTier.regional:
        return [
          knife,
          club,
          spear,
          sword,
        ];

      case EquipmentMarketTier.major:
        return [
          knife,
          club,
          spear,
          sword,
          battleAxe,
        ];
    }
  }

  static List<Armour>
      availableArmours(
    EquipmentMarketTier tier,
  ) {
    switch (tier) {
      case EquipmentMarketTier.basic:
        return [
          paddedArmour,
        ];

      case EquipmentMarketTier.regional:
        return [
          paddedArmour,
          leatherArmour,
        ];

      case EquipmentMarketTier.major:
        return [
          paddedArmour,
          leatherArmour,
          chainmail,
          plateArmour,
        ];
    }
  }

  static List<Helmet>
      availableHelmets(
    EquipmentMarketTier tier,
  ) {
    switch (tier) {
      case EquipmentMarketTier.basic:
        return [
          clothCap,
          leatherCap,
        ];

      case EquipmentMarketTier.regional:
        return [
          clothCap,
          leatherCap,
          ironHelmet,
        ];

      case EquipmentMarketTier.major:
        return [
          clothCap,
          leatherCap,
          ironHelmet,
          greatHelm,
        ];
    }
  }

  static List<Weapon>
      generateWeaponStock({
    required EquipmentMarketTier
        tier,
    required int stockSize,
  }) {
    final available =
        availableWeapons(
      tier,
    );

    return List.generate(
      stockSize,
      (_) => available[
          _random.nextInt(
        available.length,
      )],
    );
  }

  static List<Armour>
      generateArmourStock({
    required EquipmentMarketTier
        tier,
    required int stockSize,
  }) {
    final available =
        availableArmours(
      tier,
    );

    return List.generate(
      stockSize,
      (_) => available[
          _random.nextInt(
        available.length,
      )],
    );
  }

  static List<Helmet>
      generateHelmetStock({
    required EquipmentMarketTier
        tier,
    required int stockSize,
  }) {
    final available =
        availableHelmets(
      tier,
    );

    return List.generate(
      stockSize,
      (_) => available[
          _random.nextInt(
        available.length,
      )],
    );
  }

  static double weaponPrice(
    Weapon weapon,
  ) {
    return weapon.basePrice;
  }

  static double armourPrice(
    Armour armour,
  ) {
    return armour.basePrice;
  }

  static double helmetPrice(
    Helmet helmet,
  ) {
    return helmet.basePrice;
  }
}