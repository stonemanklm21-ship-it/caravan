// lib/core/quests/quest_service.dart

import '../events/game_event.dart';
import '../models/game.dart';
import 'handlers/objective_handler_registry.dart';
import 'npc_quest_state.dart';
import 'objectives/objective_progress.dart';
import 'quest_evaluator.dart';
import 'quest_instance.dart';
import 'quest_registry.dart';
import 'quest_status.dart';
import 'rewards/reward_service.dart';

class QuestService {
  final QuestRegistry questRegistry;

  final ObjectiveHandlerRegistry
      objectiveRegistry;

  final RewardService rewardService;

  int processedEvents = 0;

  QuestService({
    required this.questRegistry,
    required this.objectiveRegistry,
    required this.rewardService,
  });

  bool hasQuest({
    required String questId,
    required List<QuestInstance> activeQuests,
  }) {
    return activeQuests.any(
      (q) => q.definitionId == questId,
    );
  }

  NpcQuestState getNpcQuestState({
    required String npcId,
    required List<QuestInstance> activeQuests,
  }) {
    for (final quest in activeQuests) {
      final definition =
          questRegistry.get(
        quest.definitionId,
      );

      if (definition == null) {
        continue;
      }

      if (definition.giverId != npcId) {
        continue;
      }

      switch (quest.status) {
        case QuestStatus.active:
          return NpcQuestState.active;

        case QuestStatus.readyToTurnIn:
          return NpcQuestState.readyToTurnIn;

        case QuestStatus.completed:
          return NpcQuestState.completed;

        case QuestStatus.failed:
          return NpcQuestState.none;
      }
    }

    final availableQuests =
        questRegistry.getByGiver(
      npcId,
    );

    if (availableQuests.isNotEmpty) {
      return NpcQuestState.available;
    }

    return NpcQuestState.none;
  }

  void acceptQuest({
    required String questId,
    required List<QuestInstance> activeQuests,
  }) {
    final definition =
        questRegistry.get(questId);

    if (definition == null) {
      return;
    }

    if (hasQuest(
      questId: questId,
      activeQuests: activeQuests,
    )) {
      return;
    }

    activeQuests.add(
      QuestInstance(
        definitionId: questId,
        progress: List.generate(
          definition.objectives.length,
          (_) => ObjectiveProgress(),
        ),
      ),
    );
  }

  void turnInQuest({
    required String questId,
    required Game game,
    required List<QuestInstance> activeQuests,
  }) {
    final definition =
        questRegistry.get(questId);

    if (definition == null) {
      return;
    }

    for (final quest in activeQuests) {
      if (quest.definitionId != questId) {
        continue;
      }

      if (quest.status !=
          QuestStatus.readyToTurnIn) {
        return;
      }

      rewardService.grantRewards(
        game: game,
        rewards: definition.rewards,
      );

      quest.status =
          QuestStatus.completed;

      return;
    }
  }

  void processEvent({
    required GameEvent event,
    required List<QuestInstance> activeQuests,
  }) {
    processedEvents++;

    for (final quest in activeQuests) {
      if (quest.status !=
          QuestStatus.active) {
        continue;
      }

      final definition =
          questRegistry.get(
        quest.definitionId,
      );

      if (definition == null) {
        continue;
      }

      for (
        var i = 0;
        i < definition.objectives.length;
        i++
      ) {
        final objective =
            definition.objectives[i];

        final progress =
            quest.progress[i];

        final handler =
            objectiveRegistry.get(
          objective.type,
        );

        if (handler == null) {
          continue;
        }

        handler.process(
          event: event,
          definition: objective,
          progress: progress,
        );
      }

      if (QuestEvaluator.isComplete(
        definition: definition,
        instance: quest,
      )) {
        quest.status =
            definition.requiresTurnIn
                ? QuestStatus.readyToTurnIn
                : QuestStatus.completed;
      }
    }
  }
}