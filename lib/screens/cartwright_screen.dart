import 'package:flutter/material.dart';

import '../core/city/vehicle_repair_service.dart';
import '../core/models/player_state.dart';
import '../core/models/vehicle.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_button.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/app_card_button.dart';
import '../ui/widgets/game_scaffold.dart';
import '../ui/widgets/game_status_bar.dart';
import '../ui/widgets/status_item.dart';

class CartwrightScreen extends StatefulWidget {
  final PlayerState playerState;

  const CartwrightScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<CartwrightScreen> createState() =>
      _CartwrightScreenState();
}

class _CartwrightScreenState
    extends State<CartwrightScreen> {
  @override
  Widget build(BuildContext context) {
    final caravan =
        widget.playerState.caravan;

    final vehicles =
        caravan.vehicles;

    final hasVehicles =
        vehicles.isNotEmpty;

    final repairAllCost =
        VehicleRepairService
            .repairAllCost(
      vehicles,
    );

    final needsRepair =
        VehicleRepairService
            .canRepairAny(
      vehicles,
    );

    return GameScaffold(
      title: 'Cartwright',
      statusBar: GameStatusBar(
        children: [
          StatusItem(
            icon: '🪙',
            value: caravan.gold
                .toStringAsFixed(0),
            color: AppColors.gold,
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:
            vehicles.length + 1,
        itemBuilder: (
          context,
          index,
        ) {
          if (index == 0) {
            return AppCardButton(
              text: !hasVehicles
                  ? 'No Vehicles'
                  : needsRepair
                      ? 'Repair All\n🪙${repairAllCost.toStringAsFixed(0)}'
                      : 'Fully Repaired',
              onPressed: hasVehicles &&
                      needsRepair &&
                      caravan.gold >=
                          repairAllCost
                  ? () {
                      setState(
                        () {
                          caravan.gold -=
                              repairAllCost;

                          VehicleRepairService
                              .repairAll(
                            vehicles,
                          );
                        },
                      );
                    }
                  : null,
            );
          }

          final vehicle =
              vehicles[index - 1];

          final cost =
              VehicleRepairService
                  .repairCost(
            vehicle,
          );

          final canRepair =
              VehicleRepairService
                  .canRepair(
            vehicle,
          );

          final conditionPercent =
              vehicle.type
                          .maxCondition <=
                      0
                  ? 0.0
                  : vehicle.condition /
                      vehicle.type
                          .maxCondition;

          final conditionColor =
              conditionPercent >=
                      0.67
                  ? Colors.green
                  : conditionPercent >=
                          0.33
                      ? Colors.orange
                      : Colors.red;

          return AppCard(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  // Identity column
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration:
                            BoxDecoration(
                          border:
                              Border.all(
                            color:
                                AppColors
                                    .primary,
                            width: 1,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            6,
                          ),
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          size: 40,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        vehicle.type.name,
                        textAlign:
                            TextAlign.center,
                        style:
                            AppTextStyles
                                .section,
                      ),
                    ],
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color:
                        AppColors.accent,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // Condition column
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const Text(
                            'Condition',
                            style:
                                TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          LinearProgressIndicator(
                            value:
                                conditionPercent,
                            minHeight:
                                12,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              8,
                            ),
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              conditionColor,
                            ),
                            backgroundColor:
                                Colors.black12,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            '${vehicle.condition.toInt()} / ${vehicle.type.maxCondition.toInt()}',
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // Action column
                  SizedBox(
                    width: 84,
                    child: Opacity(
                      opacity:
                          canRepair
                              ? 1.0
                              : 0.5,
                      child:
                          AppButton(
                        text: canRepair
                            ? 'Repair\n🪙${cost.toStringAsFixed(0)}'
                            : 'Fully\nRepaired',
                        onPressed: canRepair &&
                                caravan.gold >=
                                    cost
                            ? () {
                                setState(
                                  () {
                                    caravan.gold -=
                                        cost;

                                    VehicleRepairService
                                        .repair(
                                      vehicle,
                                    );
                                  },
                                );
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}