import 'dart:io';

import 'package:csv/csv.dart';

void main() {
  final rows = readCsv(
    'lib/data/caravan_templates.csv',
  );

  final buffer = StringBuffer();

  buffer.writeln(
      '// GENERATED FILE - DO NOT EDIT');
  buffer.writeln();

  buffer.writeln('''
class CaravanTemplate {
  final String name;

  final int companions;

  final int donkeys;
  final int horses;
  final int ox;
  final int camels;

  final int smallCarts;
  final int carts;
  final int largeCarts;

  final double minGold;
  final double maxGold;

  final int weight;

  const CaravanTemplate({
    required this.name,
    required this.companions,
    required this.donkeys,
    required this.horses,
    required this.ox,
    required this.camels,
    required this.smallCarts,
    required this.carts,
    required this.largeCarts,
    required this.minGold,
    required this.maxGold,
    required this.weight,
  });
}

''');

  for (final row in rows) {
    final id = row['id'];

    buffer.writeln('''
const $id = CaravanTemplate(
  name: '${row['name']}',
  companions: ${row['companions']},
  donkeys: ${row['donkeys']},
  horses: ${row['horses']},
  ox: ${row['ox']},
  camels: ${row['camels']},
  smallCarts: ${row['smallCarts']},
  carts: ${row['carts']},
  largeCarts: ${row['largeCarts']},
  minGold: ${row['minGold']},
  maxGold: ${row['maxGold']},
  weight: ${row['weight']},
);

''');
  }

  buffer.writeln('const caravanTemplates = [');

  for (final row in rows) {
    buffer.writeln(
      '  ${row['id']},',
    );
  }

  buffer.writeln('];');

  File(
    'lib/data/caravan_templates.dart',
  ).writeAsStringSync(
    buffer.toString(),
  );

  print(
    'Generated ${rows.length} caravan templates.',
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