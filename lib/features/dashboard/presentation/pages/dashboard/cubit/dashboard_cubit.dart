import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mejoralo_cdt/common/common.dart';
import 'package:mejoralo_cdt/features/dashboard/dashboard.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  final ConnectivityInterface _connectivity;

  DashboardCubit({
    required this.getTransactionsUseCase,
    required ConnectivityInterface connectivity,
  }) : _connectivity = connectivity,
       super(
         DashboardState(
           isFetchingData: false,
           transactions: [],
           totalInvestment: 0,
           totalProfit: 0,
           averageROI: 0,
         ),
       );

  Stream<bool> get isConnectedToInternet => _connectivity.isConnected;
  void closeConnectionToStream() {
    _connectivity.dispose();
  }

  Future<void> getTransactions() async {
    emit(state.copyWith(isFetchingData: true));
    final result = await getTransactionsUseCase();
    return result.fold(
      (transactions) {
        final totalInvestment = _calculateTotalInvestment(transactions);
        final averageROI = _calculateRateOfReturn(transactions);
        final totalProfit = _calculateTotalProfit(transactions);
        final years = _getYears(transactions);
        emit(
          state.copyWith(
            isFetchingData: false,
            transactions: transactions,
            totalInvestment: totalInvestment,
            averageROI: averageROI,
            totalProfit: totalProfit,
            years: years,
          ),
        );
        return;
      },
      (failure) {
        emit(state.copyWith(isFetchingData: false));
        // Handle failure (e.g., show a message to the user)
        return;
      },
    );
  }

  double _calculateTotalProfit(List<Transaction> transactions) {
    return transactions.fold(0.0, (total, transaction) {
      return total + transaction.roi;
    });
  }

  List<String> _getYears(List<Transaction> transactions) {
    final years =
        transactions
            .map((transaction) {
              return transaction.startDate.split('-')[2];
            })
            .toSet()
            .toList();
    years.sort((a, b) => b.compareTo(a));
    return years;
  }

  double _calculateTotalInvestment(List<Transaction> transactions) {
    return transactions.fold(0.0, (total, transaction) {
      return total + transaction.amount;
    });
  }

  // double _calculateWeightedROI(List<Transaction> transactions) {
  //   double totalInvestment = 0;
  //   double totalWeightedROI = 0;

  //   for (var transaction in transactions) {
  //     totalInvestment += transaction.amount;
  //     totalWeightedROI += transaction.amount * transaction.roi;
  //   }

  //   return totalInvestment > 0 ? (totalWeightedROI / totalInvestment) * 100 : 0;
  // }

  List<BankSummary> groupTransactionsByBank(List<Transaction> transactions) {
    // Mapa para agrupar por banco
    final Map<String, Map<String, dynamic>> groupedData = {};

    for (final transaction in transactions) {
      // Verificar si el banco ya está en el mapa
      if (!groupedData.containsKey(transaction.bankName)) {
        groupedData[transaction.bankName] = {
          'totalAmount': 0.0,
          'transactionCount': 0,
          'totalROI': 0.0,
        };
      }

      // Actualizar los valores del banco
      groupedData[transaction.bankName]!['totalAmount'] += transaction.amount;
      groupedData[transaction.bankName]!['transactionCount'] += 1;
      groupedData[transaction.bankName]!['totalROI'] += transaction.roi;
    }

    // Convertir el mapa en una lista de BankSummary
    return groupedData.entries.map((entry) {
      final bankName = entry.key;
      final data = entry.value;
      final totalAmount = data['totalAmount'] as double;
      final transactionCount = data['transactionCount'] as int;
      final totalROI = data['totalROI'] as double;

      // Calcular el ROI promedio
      final averageROI =
          transactionCount > 0 ? totalROI / transactionCount : 0.0;

      return BankSummary(
        bankName: bankName,
        totalAmount: totalAmount,
        transactionCount: transactionCount,
        averageROI: averageROI,
      );
    }).toList();
  }

  double _calculateRateOfReturn(List<Transaction> transactions) {
    double totalInvestment = 0;
    double totalProfit = 0;

    for (var transaction in transactions) {
      totalInvestment += transaction.amount;
      totalProfit += transaction.roi;
    }

    return totalInvestment > 0 ? (totalProfit / totalInvestment) * 100 : 0;
  }
}

class BankSummary {
  final String bankName;
  final double totalAmount;
  final int transactionCount;
  final double averageROI;

  BankSummary({
    required this.bankName,
    required this.totalAmount,
    required this.transactionCount,
    required this.averageROI,
  });
}
