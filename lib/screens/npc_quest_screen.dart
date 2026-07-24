import 'package:flutter/material.dart';

import '../core/models/character.dart';
import '../core/quests/quest_status.dart';
import '../data/game_data.dart';
import '../data/quest_registry_data.dart';
import '../data/quest_service_data.dart';

class NpcQuestScreen extends StatelessWidget {
  final Character npc;

  const NpcQuestScreen({
    super.key,
    required this.npc,
  });

  @override
  Widget build(BuildContext context) {
    final quests =
        questRegistry.getByGiver(
      npc.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(npc.name),
      ),
      body: quests.isEmpty
          ? const Center(
              child: Text(
                'Nothing to discuss.',
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.all(16),
              children: quests
                  .map(
                    (quest) =>
                        _QuestCard(
                      questId: quest.id,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final String questId;

  const _QuestCard({
    required this.questId,
  });

  @override
  Widget build(BuildContext context) {
    final definition =
        questRegistry.get(
      questId,
    )!;

    final instance = game
        .quests.activeQuests
        .where(
          (q) =>
              q.definitionId ==
              questId,
        )
        .cast()
        .firstOrNull;

    final prerequisitesMet =
        definition
            .requiredCompletedQuestIds
            .every(
              (requiredId) =>
                  game.quests.activeQuests
                      .any(
                (q) =>
                    q.definitionId ==
                        requiredId &&
                    q.status ==
                        QuestStatus
                            .completed,
              ),
            );

    Widget action;

    if (!prerequisitesMet) {
      action = const Text(
        'Locked',
      );
    } else if (instance == null) {
      action = ElevatedButton(
        onPressed: () {
          questService.acceptQuest(
            questId: definition.id,
            activeQuests:
                game.quests.activeQuests,
          );

          Navigator.pop(context);
        },
        child: const Text(
          'Accept Quest',
        ),
      );
    } else if (instance.status ==
        QuestStatus.active) {
      action = Text(
        definition.activeText,
      );
    } else if (instance.status ==
        QuestStatus.readyToTurnIn) {
      action = ElevatedButton(
        onPressed: () {
          questService.turnInQuest(
            questId: definition.id,
            game: game,
            activeQuests:
                game.quests.activeQuests,
          );

          Navigator.pop(context);
        },
        child: const Text(
          'Turn In Quest',
        ),
      );
    } else if (instance.status ==
        QuestStatus.completed) {
      action = Text(
        definition.completedText,
      );
    } else {
      action = const Text(
        'Unavailable',
      );
    }

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              definition.title,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              definition.description,
            ),
            const SizedBox(
              height: 12,
            ),
            action,
          ],
        ),
      ),
    );
  }
}