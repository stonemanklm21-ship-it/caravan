import 'package:flutter/material.dart';

import '../core/models/character_portrait.dart';
import '../core/quests/conversation_service.dart';
import '../data/character_registry_data.dart';
import '../data/game_data.dart';
import '../data/quest_service_data.dart';
import 'npc_quest_screen.dart';

class CityResidentsScreen extends StatelessWidget {
  const CityResidentsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final city = game.player.currentCity;

    final residents = city == null
        ? []
        : characterRegistry.inCity(
            city.id,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          city == null
              ? 'Residents'
              : '${city.name} Residents',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bug_report,
            ),
            onPressed: () {
              final quests =
                  game.quests.activeQuests;

              final text = '''
currentCity=${game.player.currentCity?.id}
activeQuests=${quests.length}
eventsProcessed=${questService.processedEvents}

${quests.isEmpty
                  ? 'No active quests'
                  : quests
                      .map(
                        (q) =>
                            'id=${q.definitionId}\n'
                            'status=${q.status}\n'
                            'progress=${q.progress.first.current}',
                      )
                      .join('\n\n')}
''';

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                    'Quest Debug',
                  ),
                  content: Text(text),
                ),
              );
            },
          ),
        ],
      ),
      body: residents.isEmpty
          ? const Center(
              child: Text(
                'No residents.',
              ),
            )
          : GridView.builder(
              padding:
                  const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: residents.length,
              itemBuilder:
                  (context, index) {
                final resident =
                    residents[index];

                return Card(
                  clipBehavior:
                      Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      ConversationService
                          .talkToNpc(
                        npc: resident,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NpcQuestScreen(
                            npc: resident,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          CharacterPortrait(
                            seed: resident
                                .id.hashCode,
                            dna:
                                resident.portrait,
                            size: 128,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            resident.name,
                            textAlign:
                                TextAlign.center,
                            style:
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}