import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mejoralo_cdt/common/common.dart';
import 'package:mejoralo_cdt/core/failure/failure.dart';
import 'package:mejoralo_cdt/features/dashboard/infrastructure/driven-adapters/api/mappers/transaction_dto.dart';

import '../../../domain/models/transaction/gateway/transaction_gateway.dart';
import '../../../domain/models/transaction/transaction.dart';
import 'mappers/dto_to_entity.dart';

class TransactionApi extends TransactionGateway {
  final HttpClientInterface _httpClient;

  TransactionApi({required HttpClientInterface httpClient})
    : _httpClient = httpClient;

  @override
  Future<Either<List<Transaction>, Failure>> getTransactions() async {
    try {
      final response = await _httpClient.get(
        '/',
        queryParameters: {'user_id': 1244},
      );

      if (response.statusCode != 200) {
        return Right(Failure(message: 'Error fetching transactions'));
      }

      final body = jsonDecode(response.body);
      final data = body["data"];

      if (data == null) {
        return Right(Failure(message: 'No data found'));
      }

      final transactions =
          (body["data"] as List)
              .map(
                (transaction) => transactionDtoToEntity(
                  TransactionDTO.fromJson(transaction),
                ),
              )
              .toList();

      return Left(transactions);
    } catch (e) {
      return Left([]);
    }
  }
}
