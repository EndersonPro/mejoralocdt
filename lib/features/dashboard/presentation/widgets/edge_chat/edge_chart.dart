import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mejoralo_cdt/core/core.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'cubit/chart_cubit.dart';

class Profit {
  Profit({required this.month, required this.profit});
  final String month;
  final double profit;
}

class MonthlyROI {
  final int year;
  final int month;
  final double roi;

  MonthlyROI({required this.year, required this.month, required this.roi});
}

class EdgeChart extends StatelessWidget {
  const EdgeChart({super.key, required this.transactions});

  final List<Transaction> transactions;

  List<Profit> calculateProfitPerMonth(
    List<Transaction> transactions,
    String year,
  ) {
    Map<String, double> dailyReturns = {};

    final transactionFiltered =
        transactions
            .where((transaction) => transaction.startDate.split('-')[2] == year)
            .toList();

    for (var transaction in transactionFiltered) {
      final endDate = parseFormattedDate(transaction.endDate);
      final startDate = parseFormattedDate(transaction.startDate);

      final int durationDays = endDate.difference(startDate).inDays;

      double dailyReturn = transaction.roi / durationDays;

      // Recorrer cada día del período de inversión
      DateTime currentDate = startDate;
      while (!currentDate.isAfter(endDate)) {
        String dateKey = _formatDate(currentDate);

        // Acumular el rendimiento diario
        dailyReturns[dateKey] = (dailyReturns[dateKey] ?? 0) + dailyReturn;

        // Avanzar al siguiente día
        currentDate = currentDate.add(Duration(days: 1));
      }
    }

    final sortedEntries = SplayTreeMap<String, double>.from(
      dailyReturns,
      (a, b) => a.compareTo(b),
    );

    Map<String, double> monthlyReturns = {};

    sortedEntries.forEach((dateStr, amount) {
      // Obtener el año y mes de la fecha
      DateTime date = parseFormattedDate(dateStr);
      String monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';

      // Acumular el monto por mes
      monthlyReturns[monthKey] = (monthlyReturns[monthKey] ?? 0) + amount;
    });

    List<Profit> monthlyProfits = [];

    monthlyReturns.forEach((monthKey, profit) {
      // Obtener el año y mes de la clave
      List<String> parts = monthKey.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);

      // Formatear el mes como "Ene", "Feb", etc.
      String monthName = getMonthName(month);

      // Agregar a la lista de resultados
      monthlyProfits.add(Profit(month: monthName, profit: profit));
    });

    return monthlyProfits;
  }

  // Función auxiliar para formatear una fecha como "dd-MM-yyyy"
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  String getMonthName(int month) {
    const monthNames = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError("Month must be between 1 and 12.");
    }

    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final yearFilterSelected = context.select(
      (ChartCubit cubit) => cubit.state.yearFilterSelected,
    );

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(text: isCardView ? '' : 'Fuel price in India'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: AxisLabelIntersectAction.hide,
      ),
      primaryYAxis: NumericAxis(
        // majorTickLines: const MajorTickLines(width: 0.5),
        axisLine: const AxisLine(width: 0),
        isVisible: false,
        labelFormat: '{value}',
        labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        // minimum: 20,
        // maximum: 80,
        // edgeLabelPlacement: EdgeLabelPlacement.hide,
        // title: AxisTitle(),
      ),
      series: [
        ColumnSeries<Profit, String>(
          dataSource: calculateProfitPerMonth(transactions, yearFilterSelected),
          xValueMapper: (Profit sales, int index) => sales.month,
          yValueMapper: (Profit sales, int index) => sales.profit,
          enableTooltip: false,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
            builder: (
              dynamic data,
              dynamic point,
              dynamic series,
              int pointIndex,
              int seriesIndex,
            ) {
              return Text(
                (point.y as double).toAbbreviatedCurrency(),
                style: const TextStyle(fontSize: 10, color: Colors.black),
              );
            },
          ),
        ),
      ],
      legend: Legend(
        isVisible: false,
        // isVisible: isCardView ? false : true,
        position: LegendPosition.bottom,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: false,
        format: 'point.x : point.y',
      ),
    );
  }
}
