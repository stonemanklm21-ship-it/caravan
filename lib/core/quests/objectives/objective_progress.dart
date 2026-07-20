class ObjectiveProgress {
  int current;

  ObjectiveProgress({
    this.current = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'current': current,
    };
  }

  factory ObjectiveProgress.fromJson(
    Map<String, dynamic> json,
  ) {
    return ObjectiveProgress(
      current: json['current'] as int,
    );
  }
}