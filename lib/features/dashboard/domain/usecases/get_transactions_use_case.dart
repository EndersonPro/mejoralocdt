import 'package:dartz/dartz.dart';
import 'package:mejoralo_cdt/core/failure/failure.dart';

import '../models/transaction/gateway/transaction_gateway.dart';
import '../models/transaction/transaction.dart';

class GetTransactionsUseCase {
  final TransactionGateway _transactionGateway;

  GetTransactionsUseCase({required TransactionGateway transactionGateway})
    : _transactionGateway = transactionGateway;

  Future<Either<List<Transaction>, Failure>> call() async {
    return _transactionGateway.getTransactions();
  }
}
