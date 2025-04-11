import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mejoralo_cdt/core/failure/failure.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/gateway/transaction_gateway.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class TransactionApiCacheDecorator extends TransactionGateway {
  final TransactionGateway _transactionGateway;
  final Connectivity _connectivity;

  TransactionApiCacheDecorator(
    this._transactionGateway, {
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  @override
  Future<Either<List<Transaction>, Failure>> getTransactions() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final bool hasInternet =
        connectivityResult.first != ConnectivityResult.none;

    final database = await _getDatabase();

    if (hasInternet) {
      debugPrint('has internet');
      final apiResult = await _transactionGateway.getTransactions();

      return apiResult.fold(
        (transactions) async {
          await _saveTransactionsToCache(database, transactions);
          return Left(transactions);
        },
        (failure) async {
          final cachedTransactions = await _getTransactionsFromCache(database);
          if (cachedTransactions.isNotEmpty) {
            return Left(cachedTransactions);
          }
          return Right(failure);
        },
      );
    }
    final cachedTransactions = await _getTransactionsFromCache(database);
    if (cachedTransactions.isNotEmpty) {
      return Left(cachedTransactions);
    }
    return Right(
      CacheFailure(
        message: 'No internet connection and no cached data available',
      ),
    );
  }

  Future<sql.Database> _getDatabase() async {
    final databasesPath = await sql.getDatabasesPath();
    String path = join(databasesPath, 'cache.db');

    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS transactions(id TEXT PRIMARY KEY, data TEXT, timestamp INTEGER)',
        );
      },
    );
  }

  Future<void> _saveTransactionsToCache(
    sql.Database database,
    List<Transaction> transactions,
  ) async {
    await database.delete('transactions');
    final batch = database.batch();
    for (var transaction in transactions) {
      batch.insert('transactions', {
        'id': Uuid().v4(),
        'data': jsonEncode(transaction.toJson()),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Transaction>> _getTransactionsFromCache(
    sql.Database database,
  ) async {
    try {
      final result = await database.query('transactions');
      return result
          .map((map) => Transaction.fromJson(jsonDecode(map['data'] as String)))
          .toList();
    } catch (error) {
      debugPrint("Error getting transactions from cache");
      debugPrint(error.toString());
      return [];
    }
  }
}
