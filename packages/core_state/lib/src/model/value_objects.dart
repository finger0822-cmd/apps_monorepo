import 'package:equatable/equatable.dart';

import '../util/validators.dart';

class Rating extends Equatable {
  final int value;

  Rating(int value) : value = validateRating1to5(value);

  @override
  List<Object?> get props => <Object?>[value];

  @override
  String toString() => 'Rating($value)';
}
