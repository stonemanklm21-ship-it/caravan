import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../core/ledger/ledger_service.dart';
import '../data/cities_data.dart';
import '../data/game_data.dart';
import '../data/goods_data.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/game_scaffold.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({
    super.key,
  });

  @override
  State<LedgerScreen> createState() =>
      _LedgerScreenState();
}

class _LedgerScreenState
    extends State<LedgerScreen> {
  late String selectedCityId;
  late String selectedGoodId;

  @override
  void initState() {
    super.initState();

    selectedCityId = cities.first.id;
    selectedGoodId = goods.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final observations =
        LedgerService.observationsForCityAndGood(
      playerState: game.player,
      cityId: selectedCityId,
      goodId: selectedGoodId,
    );

final minPrice = observations.isEmpty
    ? 0.0
    : observations
        .map((o) => o.price)
        .reduce((a, b) => a < b ? a : b);

final maxPrice = observations.isEmpty
    ? 0.0
    : observations
        .map((o) => o.price)
        .reduce((a, b) => a > b ? a : b);

final range = maxPrice - minPrice;

double interval;

if (range <= 10) {
  interval = 1;
} else if (range <= 50) {
  interval = 5;
} else if (range <= 100) {
  interval = 10;
} else {
  interval = 20;
}

    return GameScaffold(
      title: 'Ledger',
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
           AppCard(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'City',
              style: AppTextStyles.section,
            ),
            DropdownButton<String>(
              value: selectedCityId,
              isExpanded: true,
              underline: const SizedBox(),
              items: cities.map(
                (city) => DropdownMenuItem(
                  value: city.id,
                  child: Text(
                    city.name,
                    style: AppTextStyles.body,
                  ),
                ),
              ).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedCityId = value;
                });
              },
            ),
          ],
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good',
              style: AppTextStyles.section,
            ),
            DropdownButton<String>(
              value: selectedGoodId,
              isExpanded: true,
              underline: const SizedBox(),
              items: goods.map(
                (good) => DropdownMenuItem(
                  value: good.id,
                  child: Text(
                    good.name,
                    style: AppTextStyles.body,
                  ),
                ),
              ).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedGoodId = value;
                });
              },
            ),
          ],
        ),
      ),
    ],
  ),
),
            const SizedBox(height: 8),
            Expanded(
              child: AppCard(
                child: Column(
                  children: [
                  
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          observations.length < 2
                              ? Center(
                                  child: Text(
                                    'Need more observations.',
                                    style:
                                        AppTextStyles
                                            .body,
                                  ),
                                )
                              : LineChart(LineChartData(
  minX:
      observations.first.day.toDouble() -
      0.5,
  maxX:
      observations.last.day.toDouble() +
      0.5,

  borderData: FlBorderData(
    show: true,
    border: Border.all(
      color: AppColors.gold,
    ),
  ),

gridData: FlGridData(
  show: true,
  drawVerticalLine: false,
  horizontalInterval: interval,
  getDrawingHorizontalLine: (value) {
    return const FlLine(
      color: Color(0x22000000),
      strokeWidth: 1,
    );
  },
),

  titlesData: FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),

    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 24,
        interval: 1,
        getTitlesWidget: (
          value,
          meta,
        ) {
          return Text(
            value.toInt().toString(),
            style: AppTextStyles.caption,
          );
        },
      ),
    ),

   leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 36,
    interval: interval,
    getTitlesWidget: (
      value,
      meta,
    ) {
      return Text(
        value.toInt().toString(),
        style: AppTextStyles.caption,
      );
    },
  ),
),
  ),

  lineBarsData: [
    LineChartBarData(
      color: AppColors.primary,
      barWidth: 3,
      isCurved: false,

      dotData: FlDotData(
        show: true,
      ),

      spots: observations
          .map(
            (observation) => FlSpot(
              observation.day.toDouble(),
              observation.price,
            ),
          )
          .toList(),
    ),
  ],
)
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}