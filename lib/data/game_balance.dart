class GameBalance {
  
  // City

  static const double citySafeZoneRadius = 50;
  
  // Population

  static const int peoplePerMerchant = 500;
  static const int merchantsPerBandit = 3;

    // Population maintenance

  static const int populationMaintenanceHours = 24;

  
  // Visibility service

  static const double banditVisionRange = 100.0;
  static const double merchantVisionRange = 110.0;
  
  // Merchants

  static const double merchantFleeRatio = 1.1;

  // Bandits

  static const double banditMinSpawnDistance = 200;
  static const double banditMaxSpawnDistance = 500;

  static const double banditLeaderPreferredWeaponChance = 0.8;
  static const double banditPreferredWeaponChance = 0.6;

  static const double banditAttackRatio = 0.5;

  static const double banditDailyGoldDecay = 0.02;

  // Combat Strength Service

  static const double combatStrengthCombatLevelWeight = 5;
  static const double combatStrengthDamageWeight = 3;
  static const double combatStrengthProtectionWeight = 2;
  static const double combatStrengthHpWeight = 20;

  static const double surrenderRatio = 2.0;

}