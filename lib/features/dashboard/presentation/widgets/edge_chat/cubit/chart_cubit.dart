import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit()
    : super(
        ChartState(
          timePeriodSelected: ChartTimePeriod.monthly,
          yearFilterSelected: '2024',
        ),
      );

  void setTimePeriod(ChartTimePeriod timePeriod) {
    emit(state.copyWith(timePeriodSelected: timePeriod));
  }

  void setYearFilterSelected(String year) {
    emit(state.copyWith(yearFilterSelected: year));
  }
}
