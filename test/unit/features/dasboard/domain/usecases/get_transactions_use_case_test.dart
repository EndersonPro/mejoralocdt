import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejoralo_cdt/core/failure/failure.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';
import 'package:mejoralo_cdt/features/features.dart';

class MockTransactionGateway extends TransactionGateway {
  @override
  Future<Either<List<Transaction>, Failure>> getTransactions() {
    return Future.value(
      Left([
        Transaction(
          userId: '233',
          amount: 9000000,
          bankName: 'Banco Test',
          endDate: '01-01-2025',
          startDate: '01-01-2024',
          roi: 902465.75,
          rate: 10,
        ),
      ]),
    );
  }
}

void main() {
  group('GetTransactionsUseCase Test', () {
    test('should return a list of transactions', () async {
      // Arrange
      final transactionGateway = MockTransactionGateway();
      final getTransactionsUseCase = GetTransactionsUseCase(
        transactionGateway: transactionGateway,
      );

      // Act
      final result = await getTransactionsUseCase();

      // Assert
      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<List<Transaction>>());
    });
  });
}
