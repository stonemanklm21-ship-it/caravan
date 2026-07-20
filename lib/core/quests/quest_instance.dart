import 'objectives/objective_progress.dart';
import 'quest_status.dart';

class QuestInstance {
  final String definitionId;

  QuestStatus status;

  final List<ObjectiveProgress> progress;

  QuestInstance({
    required this.definitionId,
    required this.progress,
    this.status = QuestStatus.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'definitionId': definitionId,
      'status': status.name,
      'progress':
          progress
              .map((p) => p.toJson())
              .toList(),
    };
  }

  factory QuestInstance.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuestInstance(
      definitionId:
          json['definitionId'] as String,
      status: QuestStatus.values
          .firstWhere(
        (s) => s.name == json['status'],
      ),
      progress:
          (json['progress'] as List)
              .map(
                (e) =>
                    ObjectiveProgress
                        .fromJson(
                  e
                      as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}