part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final bool isFetchingData;
  final List<Transaction> transactions;
  final double totalInvestment;
  final double totalProfit;
  final double averageROI;
  final List<String> years;

  const DashboardState({
    required this.transactions,
    required this.isFetchingData,
    required this.totalInvestment,
    required this.totalProfit,
    required this.averageROI,
    this.years = const [],
  });

  DashboardState copyWith({
    bool? isFetchingData,
    List<Transaction>? transactions,
    double? totalInvestment,
    double? totalProfit,
    double? averageROI,
    List<String>? years,
  }) {
    return DashboardState(
      isFetchingData: isFetchingData ?? this.isFetchingData,
      transactions: transactions ?? this.transactions,
      totalInvestment: totalInvestment ?? this.totalInvestment,
      totalProfit: totalProfit ?? this.totalProfit,
      averageROI: averageROI ?? this.averageROI,
      years: years ?? this.years,
    );
  }

  @override
  List<Object?> get props => [
    isFetchingData,
    transactions,
    totalInvestment,
    totalProfit,
    averageROI,
  ];
}
