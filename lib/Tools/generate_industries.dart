import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/industry_types.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/models/industry_type.dart';");
  buffer.writeln(
      "import 'goods_data.dart';");

  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final row in rows) {
    final id = row['id'];
    final name = row['name'];

    final inputGood1 =
        row['inputGood1']?.toString() ?? '';
    final inputQty1 =
        row['inputQty1'];

    final inputGood2 =
        row['inputGood2']?.toString() ?? '';
    final inputQty2 =
        row['inputQty2'];

    final outputGood =
        row['outputGood'];
    final outputQty =
        row['outputQty'];

    final inputsBuffer =
        StringBuffer();

    if (inputGood1.trim().isNotEmpty) {
      inputsBuffer.writeln(
          '    $inputGood1: $inputQty1,');
    }

    if (inputGood2.trim().isNotEmpty) {
      inputsBuffer.writeln(
          '    $inputGood2: $inputQty2,');
    }

    buffer.writeln('''
final $id = IndustryType(
  id: '$id',
  name: '$name',
  inputsPerSize: {
${inputsBuffer.toString()}  },
  outputsPerSize: {
    $outputGood: $outputQty,
  },
  operatingCostPerSizePerDay: ${row['operatingCost']},
  workersPerSize: ${row['workers']},
  storagePerSize: ${row['storage']},
);
''');
  }

  buffer.writeln('''
final industryTypes = [
''');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['id']},',
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