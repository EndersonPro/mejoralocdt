part of 'chart_cubit.dart';

enum ChartTimePeriod { monthly, yearly, quarterly, fourMonthly, biannual }

extension ChartTimePeriodExtension on ChartTimePeriod {
  String get name {
    switch (this) {
      case ChartTimePeriod.monthly:
        return 'Mensual';
      case ChartTimePeriod.yearly:
        return 'Anual';
      case ChartTimePeriod.quarterly:
        return 'Trimestral';
      case ChartTimePeriod.fourMonthly:
        return 'Cuatrimestral';
      case ChartTimePeriod.biannual:
        return 'Semestral';
    }
  }
}

class ChartState extends Equatable {
  const ChartState({
    required this.yearFilterSelected,
    required this.timePeriodSelected,
  });

  final String yearFilterSelected;
  final ChartTimePeriod timePeriodSelected;

  @override
  List<Object> get props => [yearFilterSelected, timePeriodSelected];

  ChartState copyWith({
    String? yearFilterSelected,
    ChartTimePeriod? timePeriodSelected,
  }) {
    return ChartState(
      yearFilterSelected: yearFilterSelected ?? this.yearFilterSelected,
      timePeriodSelected: timePeriodSelected ?? this.timePeriodSelected,
    );
  }
}
