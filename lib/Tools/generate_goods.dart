import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/goods.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/models/good.dart';");
  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final row in rows) {
    buffer.writeln('''
const ${row['variableName']} = Good(
  id: '${row['id']}',
  variableName: '${row['variableName']}',
  name: '${row['name']}',
  priceFloor: ${row['priceFloor']},
  priceCeiling: ${row['priceCeiling']},
  weight: ${row['weight']},
  caloriesPerUnit: ${row['caloriesPerUnit']},
  waterPerUnit: ${row['waterPerUnit']},
  populationDemandPerPersonPerDay: ${row['populationDemandPerPersonPerDay']},
);
''');
  }

  buffer.writeln('''
const goods = [
''');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['variableName']},',
    );
  }

  buffer.writeln('];');
  buffer.writeln();

  buffer.writeln('''
final goodsById = {
  for (final good in goods)
    good.id: good,
};

Good goodForId(
  String id,
) {
  return goodsById[id]!;
}
''');

  File(
    'lib/data/goods_data.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} goods.',
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