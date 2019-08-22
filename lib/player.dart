import 'package:meta/meta.dart';

class Player {
  final String name;
  final List<int> points;

  const Player({
    @required this.name,
    this.points,
  })  : assert(name != null),
        assert(points != null);
}
