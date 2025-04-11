import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mejoralo_cdt/common/common.dart';
import 'package:mejoralo_cdt/core/failure/failure.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/gateway/transaction_gateway.dart';
import 'package:mejoralo_cdt/features/dashboard/domain/models/transaction/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class TransactionApiCacheDecorator extends TransactionGateway {
  final TransactionGateway _transactionGateway;
  final ConnectivityInterface _connectivity;
  final Duration cacheTTL;

  TransactionApiCacheDecorator(
    this._transactionGateway, {
    required ConnectivityInterface connectivity,
    this.cacheTTL = const Duration(hours: 1), // Default TTL of 1 hour
  }) : _connectivity = connectivity;

  @override
  Future<Either<List<Transaction>, Failure>> getTransactions() async {
    // TODO: Esto genera un alto acoplamiento, pero por ahora es la mejor opción para avanzar
    final database = await _getDatabase();

    // Check if we have valid cache (not expired)
    final cacheInfo = await _getCacheInfo(database);
    final bool isCacheValid =
        cacheInfo != null &&
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(
                cacheInfo['timestamp'] as int,
              ),
            ) <
            cacheTTL;

    // If cache is valid, return cached data without checking network
    if (isCacheValid) {
      debugPrint('Using valid cache (within TTL)');
      final cachedTransactions = await _getTransactionsFromCache(database);
      if (cachedTransactions.isNotEmpty) {
        return Left(cachedTransactions);
      }
    }

    // If cache is expired or empty, check connectivity
    final hasInternet = await _connectivity.check();

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

    // No internet, try to use cache even if expired
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

  Future<Map<String, dynamic>?> _getCacheInfo(sql.Database database) async {
    try {
      final result = await database.query(
        'cache_metadata',
        where: 'key = ?',
        whereArgs: ['transactions_last_update'],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting cache info: $e');
      return null;
    }
  }

  Future<sql.Database> _getDatabase() async {
    final databasesPath = await sql.getDatabasesPath();
    String path = join(databasesPath, 'cache_app.db');

    return await sql.openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS transactions(id TEXT PRIMARY KEY, data TEXT, timestamp INTEGER)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS cache_metadata(key TEXT PRIMARY KEY, timestamp INTEGER)',
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

    // Save transactions
    for (var transaction in transactions) {
      batch.insert('transactions', {
        'id': Uuid().v4(),
        'data': jsonEncode(transaction.toJson()),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }

    // Update cache metadata with current timestamp
    final now = DateTime.now().millisecondsSinceEpoch;
    batch.insert('cache_metadata', {
      'key': 'transactions_last_update',
      'timestamp': now,
    }, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    await batch.commit(noResult: true);
    debugPrint('Cache updated at: ${DateTime.now()}');
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
