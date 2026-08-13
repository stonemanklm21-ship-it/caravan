import 'package:flutter/material.dart';

import '../../core/economy/equipment_market_service.dart';
import '../../core/models/player_state.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/widgets/app_tab_view.dart';
import '../../ui/widgets/game_scaffold.dart';
import '../../ui/widgets/game_status_bar.dart';
import '../../ui/widgets/status_item.dart';
import '../../ui/widgets/weapon_card.dart';
import '../../ui/widgets/armour_card.dart';
import '../../ui/widgets/helmet_card.dart';

class EquipmentMarketScreen
    extends StatefulWidget {
  final PlayerState playerState;

  const EquipmentMarketScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<EquipmentMarketScreen>
      createState() =>
          _EquipmentMarketScreenState();
}

class _EquipmentMarketScreenState
    extends State<
        EquipmentMarketScreen> {
  @override
  void initState() {
    super.initState();

    EquipmentMarketService
        .refreshMarket(
      city:
          widget.playerState.currentCity!,
      currentHour:
          widget.playerState
              .worldTimeHours
              .floor(),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final city =
        widget.playerState.currentCity!;

    final caravan =
        widget.playerState.caravan;

    return GameScaffold(
      title: 'Equipment Market',
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
      child: AppTabView(
        tabs: const [
          'Weapons',
          'Armour',
          'Helmets',
        ],
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: city
                .weaponMarketStock
                .map(
                  (weapon) =>
                      WeaponMarketCard(
                    weapon: weapon,
                    gold: caravan.gold,
                    onBuy: () {
                      setState(() {
                        caravan.gold -=
                            weapon.basePrice;

                        caravan.weapons
                            .add(
                          weapon,
                        );

                        city
                            .weaponMarketStock
                            .remove(
                          weapon,
                        );
                      });
                    },
                  ),
                )
                .toList(),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: city
                .armourMarketStock
                .map(
                  (armour) =>
                      ArmourMarketCard(
                    armour: armour,
                    gold: caravan.gold,
                    onBuy: () {
                      setState(() {
                        caravan.gold -=
                            armour.basePrice;

                        caravan.armours
                            .add(
                          armour,
                        );

                        city
                            .armourMarketStock
                            .remove(
                          armour,
                        );
                      });
                    },
                  ),
                )
                .toList(),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: city
                .helmetMarketStock
                .map(
                  (helmet) =>
                      HelmetMarketCard(
                    helmet: helmet,
                    gold: caravan.gold,
                    onBuy: () {
                      setState(() {
                        caravan.gold -=
                            helmet.basePrice;

                        caravan.helmets
                            .add(
                          helmet,
                        );

                        city
                            .helmetMarketStock
                            .remove(
                          helmet,
                        );
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}