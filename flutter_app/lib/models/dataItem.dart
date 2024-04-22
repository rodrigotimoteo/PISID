/// Represents a data item with numerical properties.
///
/// This class encapsulates the properties and behavior related to a single data item,
/// which includes numerical values for `x`, `y1`, `y2`, and `y3`.
class DataItem {

  /// The value of the x-coordinate.
  final int x;

  /// The value of the first y-coordinate.
  final double y1;

  /// The value of the second y-coordinate.
  final double y2;

  /// The value of the third y-coordinate.
  final double y3;

  /// Constructs a [DataItem] with the provided values.
  ///
  /// The [x] parameter represents the x-coordinate value.
  /// The [y1] parameter represents the first y-coordinate value.
  /// The [y2] parameter represents the second y-coordinate value.
  /// The [y3] parameter represents the third y-coordinate value.
  DataItem({
    required this.x,
    required this.y1,
    required this.y2,
    required this.y3,
  });
}
