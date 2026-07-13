import 'package:flutter/material.dart';
import '../../core/economy/equipment_market_service.dart';
import '../../core/models/player_state.dart';
import '../../core/models/weapon.dart';
import '../../core/models/armour.dart';
import '../../core/models/helmet.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Equipment Market',
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(12),
        children: [
          const Text(
            'Weapons',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          ...city.weaponMarketStock.map(
            (weapon) =>
                _WeaponTile(
              weapon: weapon,
              gold: widget
                  .playerState
                  .caravan
                  .gold,
              onBuy: () {
                setState(() {
                  widget
                      .playerState
                      .caravan
                      .gold -=
                      weapon.basePrice;

                  widget
                      .playerState
                      .caravan
                      .weapons
                      .add(weapon);

                  city.weaponMarketStock
                      .remove(
                    weapon,
                  );
                });
              },
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'Armour',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          ...city.armourMarketStock.map(
            (armour) =>
                _ArmourTile(
              armour: armour,
              gold: widget
                  .playerState
                  .caravan
                  .gold,
              onBuy: () {
                setState(() {
                  widget
                      .playerState
                      .caravan
                      .gold -=
                      armour.basePrice;

                  widget
                      .playerState
                      .caravan
                      .armours
                      .add(armour);

                  city.armourMarketStock
                      .remove(
                    armour,
                  );
                });
              },
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'Helmets',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          ...city.helmetMarketStock.map(
            (helmet) =>
                _HelmetTile(
              helmet: helmet,
              gold: widget
                  .playerState
                  .caravan
                  .gold,
              onBuy: () {
                setState(() {
                  widget
                      .playerState
                      .caravan
                      .gold -=
                      helmet.basePrice;

                  widget
                      .playerState
                      .caravan
                      .helmets
                      .add(helmet);

                  city.helmetMarketStock
                      .remove(
                    helmet,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeaponTile
    extends StatelessWidget {
  final Weapon weapon;
  final double gold;
  final VoidCallback onBuy;

  const _WeaponTile({
    required this.weapon,
    required this.gold,
    required this.onBuy,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          weapon.name,
        ),
        subtitle: Text(
          'Accuracy +${weapon.accuracy} • '
          'd${weapon.damageDie} • '
          '${weapon.weightKg}kg • '
          '${weapon.basePrice.toStringAsFixed(0)} gold',
        ),
        trailing: ElevatedButton(
          onPressed:
              gold < weapon.basePrice
                  ? null
                  : onBuy,
          child: const Text(
            'Buy',
          ),
        ),
      ),
    );
  }
}

class _ArmourTile
    extends StatelessWidget {
  final Armour armour;
  final double gold;
  final VoidCallback onBuy;

  const _ArmourTile({
    required this.armour,
    required this.gold,
    required this.onBuy,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          armour.name,
        ),
        subtitle: Text(
          'Protection +${armour.protection} • '
          '${armour.weightKg}kg • '
          '${armour.basePrice.toStringAsFixed(0)} gold',
        ),
        trailing: ElevatedButton(
          onPressed:
              gold < armour.basePrice
                  ? null
                  : onBuy,
          child: const Text(
            'Buy',
          ),
        ),
      ),
    );
  }
}

class _HelmetTile
    extends StatelessWidget {
  final Helmet helmet;
  final double gold;
  final VoidCallback onBuy;

  const _HelmetTile({
    required this.helmet,
    required this.gold,
    required this.onBuy,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          helmet.name,
        ),
        subtitle: Text(
          'Protection +${helmet.protection} • '
          '${helmet.weightKg}kg • '
          '${helmet.basePrice.toStringAsFixed(0)} gold',
        ),
        trailing: ElevatedButton(
          onPressed:
              gold < helmet.basePrice
                  ? null
                  : onBuy,
          child: const Text(
            'Buy',
          ),
        ),
      ),
    );
  }
}