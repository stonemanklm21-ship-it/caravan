import 'package:flutter/material.dart';

import '../core/ledger/ledger_service.dart';
import '../data/game_data.dart';
import '../data/goods_data.dart';
import '../data/cities_data.dart';

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
  late String selectedGoodId;

  @override
  void initState() {
    super.initState();

    selectedGoodId =
        goods.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final observations =
        LedgerService.observationsForGood(
      playerState: game.player,
      goodId: selectedGoodId,
    );

    observations.sort(
      (a, b) => a.cityId.compareTo(
        b.cityId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ledger',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedGoodId,
              isExpanded: true,
              items: goods
                  .map(
                    (good) =>
                        DropdownMenuItem(
                      value: good.id,
                      child: Text(
                        good.name,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedGoodId =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            Expanded(
              child:
                  observations.isEmpty
                      ? const Center(
                          child: Text(
                            'No observations recorded.',
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              observations
                                  .length,
                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                            final observation =
                                observations[
                                    index];

                            return Card(
                              child: ListTile(
                                title: Text(
                                  cityForId(
                                    observation
                                        .cityId,
                                  ).name,
                                ),
                                subtitle:
                                    Text(
                                  'Observed Day '
                                  '${observation.day} '
                                  'at '
                                  '${observation.hour.toString().padLeft(2, '0')}:00',
                                ),
                                trailing:
                                    Text(
                                  '${observation.price.toStringAsFixed(2)}g',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}