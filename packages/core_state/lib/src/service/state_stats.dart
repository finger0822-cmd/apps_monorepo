import 'package:equatable/equatable.dart';

class StateStats extends Equatable {
  final double avgEnergy;
  final double avgFocus;
  final double avgFatigue;

  final int minEnergy;
  final int maxEnergy;
  final int rangeEnergy;

  final int minFocus;
  final int maxFocus;
  final int rangeFocus;

  final int minFatigue;
  final int maxFatigue;
  final int rangeFatigue;

  final double trendEnergy;
  final double trendFocus;
  final double trendFatigue;

  final int daysCount;
  final int missingDaysCount;

  const StateStats({
    required this.avgEnergy,
    required this.avgFocus,
    required this.avgFatigue,
    required this.minEnergy,
    required this.maxEnergy,
    required this.rangeEnergy,
    required this.minFocus,
    required this.maxFocus,
    required this.rangeFocus,
    required this.minFatigue,
    required this.maxFatigue,
    required this.rangeFatigue,
    required this.trendEnergy,
    required this.trendFocus,
    required this.trendFatigue,
    required this.daysCount,
    required this.missingDaysCount,
  });

  factory StateStats.empty({int missingDaysCount = 0}) {
    return StateStats(
      avgEnergy: 0,
      avgFocus: 0,
      avgFatigue: 0,
      minEnergy: 0,
      maxEnergy: 0,
      rangeEnergy: 0,
      minFocus: 0,
      maxFocus: 0,
      rangeFocus: 0,
      minFatigue: 0,
      maxFatigue: 0,
      rangeFatigue: 0,
      trendEnergy: 0,
      trendFocus: 0,
      trendFatigue: 0,
      daysCount: 0,
      missingDaysCount: missingDaysCount,
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'avgEnergy': avgEnergy,
      'avgFocus': avgFocus,
      'avgFatigue': avgFatigue,
      'minEnergy': minEnergy,
      'maxEnergy': maxEnergy,
      'rangeEnergy': rangeEnergy,
      'minFocus': minFocus,
      'maxFocus': maxFocus,
      'rangeFocus': rangeFocus,
      'minFatigue': minFatigue,
      'maxFatigue': maxFatigue,
      'rangeFatigue': rangeFatigue,
      'trendEnergy': trendEnergy,
      'trendFocus': trendFocus,
      'trendFatigue': trendFatigue,
      'daysCount': daysCount,
      'missingDaysCount': missingDaysCount,
    };
  }

  @override
  List<Object?> get props => <Object?>[
        avgEnergy,
        avgFocus,
        avgFatigue,
        minEnergy,
        maxEnergy,
        rangeEnergy,
        minFocus,
        maxFocus,
        rangeFocus,
        minFatigue,
        maxFatigue,
        rangeFatigue,
        trendEnergy,
        trendFocus,
        trendFatigue,
        daysCount,
        missingDaysCount,
      ];
}
