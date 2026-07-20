import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../data/quest_service_data.dart';
import 'npc_quest_screen.dart';

class CityResidentsScreen
    extends StatelessWidget {
  const CityResidentsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final city =
        game.player.currentCity;

    final residents =
        city?.residents ?? [];

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
                builder: (_) =>
                    AlertDialog(
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
          : ListView.builder(
              itemCount:
                  residents.length,
              itemBuilder:
                  (context, index) {
                final resident =
                    residents[index];

                return ListTile(
                  title: Text(
                    resident.name,
                  ),
                  onTap: () {
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
                );
              },
            ),
    );
  }
}