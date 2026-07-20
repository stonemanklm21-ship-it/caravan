import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/weapons.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      "import '../core/models/weapon.dart';");
  buffer.writeln();
  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  for (final row in rows) {
    buffer.writeln('''
const ${row['variableName']} = Weapon(
  id: '${row['id']}',
  name: '${row['name']}',
  accuracy: ${row['accuracy']},
  damageDie: ${row['damageDie']},
  weightKg: ${row['weightKg']},
  basePrice: ${row['basePrice']},
);

''');
  }

  buffer.writeln(
      'const weapons = <Weapon>[');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['variableName']},',
    );
  }

  buffer.writeln('];');
  buffer.writeln();

  buffer.writeln('''
Weapon weaponForId(
  String id,
) {
  return weapons.firstWhere(
    (weapon) => weapon.id == id,
  );
}
''');

  File(
    'lib/data/weapon_data.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} weapons.',
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