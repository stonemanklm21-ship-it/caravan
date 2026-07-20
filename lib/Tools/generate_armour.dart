import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/armours.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/models/armour.dart';");
  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final row in rows) {
    buffer.writeln('''
const ${row['variableName']} = Armour(
  id: '${row['id']}',
  name: '${row['name']}',
  protection: ${row['protection']},
  weightKg: ${row['weightKg']},
  basePrice: ${row['basePrice']},
);

''');
  }

  buffer.writeln(
      'const armours = <Armour>[');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['variableName']},',
    );
  }

  buffer.writeln('];');
  buffer.writeln();

  buffer.writeln('''
Armour armourForId(
  String id,
) {
  return armours.firstWhere(
    (armour) => armour.id == id,
  );
}
''');

  File(
    'lib/data/armour_data_new.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} armours.',
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