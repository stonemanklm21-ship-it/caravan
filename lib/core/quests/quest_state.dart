import 'quest_instance.dart';

class QuestState {
  final List<QuestInstance> activeQuests;

  QuestState({
    required this.activeQuests,
  });

  Map<String, dynamic> toJson() {
    return {
      'activeQuests': activeQuests
          .map((q) => q.toJson())
          .toList(),
    };
  }

  factory QuestState.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuestState(
      activeQuests:
          (json['activeQuests'] as List)
              .map(
                (e) => QuestInstance
                    .fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}