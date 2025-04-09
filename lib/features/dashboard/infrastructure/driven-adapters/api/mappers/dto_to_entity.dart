import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';
import 'package:mejoralo_cdt/features/dashboard/infrastructure/driven-adapters/api/mappers/transaction_dto.dart';

Transaction transactionDtoToEntity(TransactionDTO transactionDto) {
  return Transaction(
    userId: transactionDto.userId.toString(),
    amount: transactionDto.amount.toDouble(),
    bankName: transactionDto.bankName,
    startDate: transactionDto.startDate,
    endDate: transactionDto.endDate,
    rate: transactionDto.rate.toDouble(),
    roi: transactionDto.roi.toDouble(),
  );
}
