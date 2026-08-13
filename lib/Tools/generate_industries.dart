import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/industry_types.csv',
  );

  final rowsByOutputGood = {
    for (final row in rows)
      row['outputGood'].toString(): row,
  };

  final buffer = StringBuffer();

  buffer.writeln(
      "import 'game_balance.dart';");
  buffer.writeln(
      "import '../core/models/industry_type.dart';");
  buffer.writeln(
      "import 'goods_data.dart';");

  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  final demandDrivenRows = rows.where(
    (row) =>
        row['derivedFromDemand']
                .toString()
                .toLowerCase() ==
            'true',
  );

  for (final row in demandDrivenRows) {
    writeIndustry(
      buffer: buffer,
      row: row,
      demandDriven: true,
    );
  }

  final supplyDrivenRows = rows.where(
    (row) =>
        row['derivedFromDemand']
                .toString()
                .toLowerCase() ==
            'false',
  );

  for (final row in supplyDrivenRows) {
    final outputGood =
        row['outputGood'].toString();

    writeIndustry(
      buffer: buffer,
      row: row,
      demandDriven: false,
      outputExpression:
          requiredOutputForGood(
        good: outputGood,
        rowsByOutputGood:
            rowsByOutputGood,
        rows: rows,
      ),
    );
  }

  buffer.writeln('''
final industryTypes = [
''');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['variableName']},',
    );
  }

  buffer.writeln('];');

  buffer.writeln('''
final industryTypesById = {
  for (final type in industryTypes)
    type.id: type,
};

IndustryType industryTypeForId(
  String id,
) {
  return industryTypesById[id]!;
}
''');

  File(
    'lib/data/industry_data.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} industry types.',
  );
}

String requiredOutputForGood({
  required String good,
  required Map<String, Map<String, dynamic>>
      rowsByOutputGood,
  required List<Map<String, dynamic>> rows,
  Set<String>? visiting,
}) {
  visiting ??= {};

  if (!visiting.add(good)) {
    throw Exception(
      'Circular dependency detected for $good',
    );
  }

  final producerRow =
      rowsByOutputGood[good]!;

  final demandDriven =
      producerRow['derivedFromDemand']
              .toString()
              .toLowerCase() ==
          'true';

  if (demandDriven) {
    return '''
GameBalance.outputForDemand(
  $good.populationDemandPerPersonPerDay,
)
''';
  }

  final consumers = rows.where(
    (row) =>
        row['inputGood1']
                .toString()
                .trim() ==
            good ||
        row['inputGood2']
                .toString()
                .trim() ==
            good,
  );

  return consumers.map((consumer) {
    final consumerOutputGood =
        consumer['outputGood']
            .toString();

    final requiredOutput =
        requiredOutputForGood(
      good: consumerOutputGood,
      rowsByOutputGood:
          rowsByOutputGood,
      rows: rows,
      visiting: {
        ...visiting!,
      },
    );

    if (consumer['inputGood1']
            .toString()
            .trim() ==
        good) {
      return '''
(
  $requiredOutput
) * ${consumer['inputRatio1']}
''';
    }

    return '''
(
  $requiredOutput
) * ${consumer['inputRatio2']}
''';
  }).join(' + ');
}

void writeIndustry({
  required StringBuffer buffer,
  required Map<String, dynamic> row,
  required bool demandDriven,
  String? outputExpression,
}) {
  final id =
      row['id'].toString();

  final variableName =
      row['variableName'].toString();

  final name =
      row['name'].toString();

  final outputGood =
      row['outputGood'].toString();

  final outputExpr = demandDriven
      ? 'GameBalance.outputForDemand($outputGood.populationDemandPerPersonPerDay)'
      : outputExpression!;

  final inputsBuffer =
      StringBuffer();

  final inputGood1 =
      row['inputGood1']
              ?.toString()
              .trim() ??
          '';

  if (inputGood1.isNotEmpty) {
    inputsBuffer.writeln('''
    $inputGood1:
        ($outputExpr) *
        ${row['inputRatio1']},
''');
  }

  final inputGood2 =
      row['inputGood2']
              ?.toString()
              .trim() ??
          '';

  if (inputGood2.isNotEmpty) {
    inputsBuffer.writeln('''
    $inputGood2:
        ($outputExpr) *
        ${row['inputRatio2']},
''');
  }

  buffer.writeln('''
final $variableName = IndustryType(
  id: '$id',
  name: '$name',
  inputsPerSize: {
${inputsBuffer.toString()}  },
  outputsPerSize: {
    $outputGood: $outputExpr,
  },
  operatingCostPerSizePerDay:
      ${row['operatingCost']},
  workersPerSize:
      ${row['workers']},
  storagePerSize:
      ${row['storage']},
);
''');
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