import 'package:flutter/material.dart';

import '../../core/economy/vehicle_market_service.dart';
import '../../core/models/player_state.dart';
import '../../core/models/vehicle.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/game_scaffold.dart';
import '../../ui/widgets/game_status_bar.dart';
import '../../ui/widgets/status_item.dart';

class VehicleMarketScreen
    extends StatefulWidget {
  final PlayerState playerState;

  final VehicleMarketTier tier;

  const VehicleMarketScreen({
    super.key,
    required this.playerState,
    required this.tier,
  });

  @override
  State<VehicleMarketScreen>
      createState() =>
          _VehicleMarketScreenState();
}

class _VehicleMarketScreenState
    extends State<VehicleMarketScreen> {
  late List<Vehicle> stock;

  @override
  void initState() {
    super.initState();

    stock =
        VehicleMarketService
            .marketStock(
      city:
          widget.playerState.currentCity!,
      currentHour:
          widget.playerState
              .worldTimeHours
              .floor(),
      stockSize: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final caravan =
        widget.playerState.caravan;

    return GameScaffold(
      title: 'Vehicle Dealer',
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
        itemCount: stock.length,
        itemBuilder:
            (context, index) {
          final vehicle =
              stock[index];

          final price =
              VehicleMarketService
                  .price(
            vehicle,
          );

          final canBuy =
              caravan.gold >=
                  price;

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
                            TextAlign
                                .center,
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

                  // Stats column
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cargo Capacity',
                              style:
                                  AppTextStyles
                                      .caption,
                            ),
                            const Spacer(),
                            Text(
                              '${vehicle.type.maxCargoKg.toStringAsFixed(0)}kg',
                              style:
                                  AppTextStyles
                                      .statValue,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          children: [
                            Text(
                              'Required Pull',
                              style:
                                  AppTextStyles
                                      .caption,
                            ),
                            const Spacer(),
                            Text(
                              '${vehicle.type.requiredPullingCapacityKg.toStringAsFixed(0)}kg',
                              style:
                                  AppTextStyles
                                      .statValue,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(
                          children: [
                            Text(
                              'Condition',
                              style:
                                  AppTextStyles
                                      .caption,
                            ),
                            const Spacer(),
                            Text(
                              '${vehicle.condition.toInt()}/${vehicle.type.maxCondition.toInt()}',
                              style:
                                  AppTextStyles
                                      .statValue,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          children: [
                            Text(
                              'Cargo Multiplier',
                              style:
                                  AppTextStyles
                                      .caption,
                            ),
                            const Spacer(),
                            Text(
                              '${vehicle.type.capacityMultiplier.toStringAsFixed(1)}x',
                              style:
                                  AppTextStyles
                                      .statValue,
                            ),
                          ],
                        ),
                      ],
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
                          canBuy
                              ? 1.0
                              : 0.5,
                      child:
                          AppButton(
                        text:
                            'Buy\n🪙\n${price.toStringAsFixed(0)}',
                        onPressed:
                            canBuy
                                ? () {
                                    setState(
                                      () {
                                        caravan.gold -=
                                            price;

                                        caravan
                                            .vehicles
                                            .add(
                                              vehicle,
                                            );

                                        stock
                                            .removeAt(
                                          index,
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