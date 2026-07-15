import '../core/models/region.dart';

const heartlands = Region(
  id: 'heartlands',
  name: 'Heartlands',
  level: 1,
);

final regions = [
  heartlands,
];

final regionsById = {
  for (final region in regions)
    region.id: region,
};

Region regionForId(
  String id,
) {
  return regionsById[id]!;
}
