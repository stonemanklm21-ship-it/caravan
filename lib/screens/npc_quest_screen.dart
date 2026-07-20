import 'package:flutter/material.dart';

import '../core/models/character.dart';
import '../core/quests/npc_quest_interaction.dart';
import '../core/quests/npc_quest_state.dart';
import '../data/game_data.dart';
import '../data/quest_service_data.dart';

class NpcQuestScreen extends StatelessWidget {
  final Character npc;

  const NpcQuestScreen({
    super.key,
    required this.npc,
  });

  @override
  Widget build(BuildContext context) {
    final interaction =
        NpcQuestInteraction(
      questService: questService,
    );

    final state =
        interaction.getState(
      npcId: npc.id,
      game: game,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(npc.name),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: switch (state) {
          NpcQuestState.available =>
            _AvailableQuestView(
              npc: npc,
            ),

          NpcQuestState.active =>
            const Center(
              child: Text(
                'Quest in progress.',
              ),
            ),

          NpcQuestState.readyToTurnIn =>
            _ReadyToTurnInView(
              npc: npc,
            ),

          NpcQuestState.completed =>
            const Center(
              child: Text(
                'Thanks for your help.',
              ),
            ),

          NpcQuestState.none =>
            const Center(
              child: Text(
                'Nothing to discuss.',
              ),
            ),
        },
      ),
    );
  }
}

class _AvailableQuestView
    extends StatelessWidget {
  final Character npc;

  const _AvailableQuestView({
    required this.npc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Visit Mining Town',
        ),
        const SizedBox(height: 8),
        const Text(
          'Travel to Mining Town.',
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            questService.acceptQuest(
              questId:
                  'visit_miningTown',
              activeQuests: game
                  .quests.activeQuests,
            );

            Navigator.pop(context);
          },
          child: const Text(
            'Accept Quest',
          ),
        ),
      ],
    );
  }
}

class _ReadyToTurnInView
    extends StatelessWidget {
  final Character npc;

  const _ReadyToTurnInView({
    required this.npc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Visit Mining Town',
        ),
        const SizedBox(height: 8),
        const Text(
          'Quest complete.',
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            questService.turnInQuest(
              questId:
                  'visit_miningTown',
              game: game,
              activeQuests: game
                  .quests.activeQuests,
            );

            Navigator.pop(context);
          },
          child: const Text(
            'Turn In Quest',
          ),
        ),
      ],
    );
  }
}