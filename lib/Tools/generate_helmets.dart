import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/helmets.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/models/helmet.dart';");
  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final row in rows) {
    buffer.writeln('''
const ${row['variableName']} = Helmet(
  id: '${row['id']}',
  name: '${row['name']}',
  protection: ${row['protection']},
  weightKg: ${row['weightKg']},
  basePrice: ${row['basePrice']},
);

''');
  }

  buffer.writeln(
      'const helmets = <Helmet>[');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['variableName']},',
    );
  }

  buffer.writeln('];');
  buffer.writeln();

  buffer.writeln('''
Helmet helmetForId(
  String id,
) {
  return helmets.firstWhere(
    (helmet) => helmet.id == id,
  );
}
''');

  File(
    'lib/data/helmet_data.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} helmets.',
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
      .map((e) => e.toString().trim())
      .toList();

  return rows.skip(1).map((row) {
    return Map<String, dynamic>.fromIterables(
      headers,
      row,
    );
  }).toList();
}