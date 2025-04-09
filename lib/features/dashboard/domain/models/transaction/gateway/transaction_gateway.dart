import 'package:dartz/dartz.dart';
import 'package:mejoralo_cdt/core/core.dart';

import '../transaction.dart';

abstract class TransactionGateway {
  Future<Either<List<Transaction>, Failure>> getTransactions();
}
