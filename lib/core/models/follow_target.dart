class FollowTarget {
  final double Function() getX;

  final double Function() getY;

  const FollowTarget({
    required this.getX,
    required this.getY,
  });
}