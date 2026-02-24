import 'package:equatable/equatable.dart';

import '../util/date_normalizer.dart';

abstract class StateEntry extends Equatable {
  final String id;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StateEntry({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  DateTime get normalizedDate => normalizeToDay(date);

  StateEntry copyWith({
    String? id,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  List<Object?> get props => <Object?>[
        id,
        normalizeToDay(date),
        createdAt,
        updatedAt,
      ];
}
