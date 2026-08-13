class GameBalance {
  
  // City

  static const double citySafeZoneRadius = 50;
  
  // Population

  static const int peoplePerMerchant = 300;
  static const int merchantsPerBandit = 5;

    // Population maintenance

  static const int populationMaintenanceHours = 24;

  // Economy

  static const int supportedPopulationPerIndustrySize =    2000;

  static double outputForDemand(  double demandPerPersonPerDay,) {
    return supportedPopulationPerIndustrySize *      demandPerPersonPerDay;}

  static const double breadDemandPerPersonPerDay =    0.1;
  static const double turnipDemandPerPersonPerDay =    0.1;
  static const double waterDemandPerPersonPerDay =    0.01;
  static const double toolsDemandPerPersonPerDay =    0.01;
  static const double woodDemandPerPersonPerDay =    0.02;
  static const double chairDemandPerPersonPerDay =    0.01;

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

  // Skills

  static const double scoutXpPerTravelHour = 3.0;
  static const double mechanicPerTravelHour = 3.0;
  static const double doctorPerTravelHour = 10.0;
  static const double vetPerTravelHour = 10.0;
}