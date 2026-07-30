import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:merchantcaravan/data/goods_data.dart';

void main() {
  final cityRows = readCsv(
    'lib/data/cities.csv',
  );

  final industryRows = readCsv(
    'lib/data/industries.csv',
  );

  final industriesByCity =
      <String, List<Map<String, dynamic>>>{};

  for (final industry in industryRows) {
    final cityId =
        industry['cityId'] as String;

    industriesByCity.putIfAbsent(
      cityId,
      () => [],
    );

    industriesByCity[cityId]!.add(
      industry,
    );
  }

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/economy/animal_market_service.dart';");
  buffer.writeln(
      "import '../core/economy/vehicle_market_service.dart';");
  buffer.writeln(
      "import '../core/economy/equipment_market_service.dart';");
  buffer.writeln(
      "import '../core/city/recruitment_service.dart';");

  buffer.writeln(
      "import '../core/models/city.dart';");
  buffer.writeln(
      "import '../core/models/industry.dart';");
  buffer.writeln(
      "import '../core/models/market_good.dart';");

  buffer.writeln(
      "import 'goods_data.dart';");
  buffer.writeln(
      "import 'industry_data.dart';");
  buffer.writeln(
      "import 'region_data.dart';");

  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final city in cityRows) {
    final cityId =
        city['id'] as String;

    final industries =
        industriesByCity[cityId] ?? [];

    final industriesBuffer =
        StringBuffer();

    for (final industry
        in industries) {
      industriesBuffer.writeln('''
    Industry(
      type: ${industry['type']},
      size: ${industry['size']},
      inputDaysTarget: ${industry['inputDaysTarget']},
      cash: ${industry['cash']},
      inventory: [],
    ),
''');
    }

    final marketGoodsBuffer =
        StringBuffer();

    final random = Random(
      cityId.hashCode,
    );

    final population =
        city['population'] as int;

    for (final good in goods) {
      final demandPerDay =
          population *
          good.populationDemandPerPersonPerDay;

      final randomFactor =
          0.75 +
          random.nextDouble() * 0.5;

      final quantity =
          (demandPerDay *
                  2 *
                  randomFactor)
              .round();

      marketGoodsBuffer.writeln('''
    MarketGood(
      good: ${good.variableName},
      quantity: $quantity,
    ),
''');
    }

    buffer.writeln('''
final $cityId = City(
  id: '$cityId',
  name: '${city['name']}',
  region: ${city['region']},
  x: ${city['x']},
  y: ${city['y']},
  population: $population,

  industries: [
${industriesBuffer.toString()}  ],

  marketGoods: [
${marketGoodsBuffer.toString()}  ],

  animalMarketTier:
      AnimalMarketTier.${city['animalMarketTier']},

  vehicleMarketTier:
      VehicleMarketTier.${city['vehicleMarketTier']},

  equipmentMarketTier:
      EquipmentMarketTier.${city['equipmentMarketTier']},

  recruitmentMarketTier:
      RecruitmentMarketTier.${city['recruitmentMarketTier']},

  hasVet:
      ${csvBool(city['hasVet'])},

  hasCartwright:
      ${csvBool(city['hasCartwright'])},

  hasDoctor:
      ${csvBool(city['hasDoctor'])},
);
''');
  }

  buffer.writeln('''
final cities = [
''');

  for (final city in cityRows) {
    buffer.writeln(
      '  ${city['id']},',
    );
  }

  buffer.writeln('];');

  buffer.writeln('''
final citiesById = {
  for (final city in cities)
    city.id: city,
};

City cityForId(
  String id,
) {
  return citiesById[id]!;
}
''');

  File(
    'lib/data/cities_data.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${cityRows.length} cities.',
  );
}

List<Map<String, dynamic>> readCsv(
  String path,
) {
  final csvText =
      File(path).readAsStringSync();

  final rows =
      const CsvToListConverter().convert(
    csvText,
  );

  final headers = rows.first
      .map(
        (e) => e.toString().trim(),
      )
      .toList();

  return rows.skip(1).map((row) {
    return Map<String, dynamic>.fromIterables(
      headers,
      row,
    );
  }).toList();
}

bool csvBool(dynamic value) {
  return value
          .toString()
          .trim()
          .toLowerCase() ==
      'true';
}