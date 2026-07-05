import 'package:flutter/material.dart';

import '../../core/economy/animal_market_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/player_state.dart';
import '../../core/world/calendar_service.dart';

class AnimalMarketScreen
    extends StatefulWidget {
  final PlayerState playerState;

  final AnimalMarketTier tier;

  const AnimalMarketScreen({
    super.key,
    required this.playerState,
    required this.tier,
  });

  @override
  State<AnimalMarketScreen> createState() =>
      _AnimalMarketScreenState();
}

class _AnimalMarketScreenState
    extends State<AnimalMarketScreen> {
  late List<Animal> stock;

  @override
  void initState() {
    super.initState();

    stock =
        AnimalMarketService.generateStock(
      tier: widget.tier,
      stockSize: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animal Market',
        ),
      ),
      body: ListView.builder(
        itemCount: stock.length,
        itemBuilder:
            (context, index) {
          final animal = stock[index];

          final price =
              AnimalMarketService
                  .price(
            animal,
          );

          return Card(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                animal.type.name,
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Gender: ${animal.gender.name}',
                  ),
                  Text(
                    'Age: ${CalendarService.formatAge(animal.ageYears)}',
                  ),
                  Text(
                    'Weight: ${animal.adultWeightKg.toStringAsFixed(1)} kg'
                    ' (adult)',
                  ),
                  Text(
                    'HP: ${animal.hp.toStringAsFixed(0)}'
                    ' / ${animal.type.maxHp.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Price: ${price.toStringAsFixed(0)}',
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed:
                    widget.playerState
                                .caravan
                                .gold <
                            price
                        ? null
                        : () {
                            setState(() {
                              widget
                                  .playerState
                                  .caravan
                                  .gold -= price;

                              widget
                                  .playerState
                                  .caravan
                                  .animals
                                  .add(animal);

                              stock.removeAt(
                                index,
                              );
                            });
                          },
                child: const Text(
                  'Buy',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}