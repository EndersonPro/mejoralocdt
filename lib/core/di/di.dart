import 'package:get_it/get_it.dart';

import '../../common/common.dart';
import '../../features/features.dart';
import '../config/environment.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<EnvironmentConfigInterface>(EnvironmentAppConfig());
  getIt.registerLazySingleton<LoggerInterface>(() => LoggerImpl());
  getIt.registerLazySingleton<HttpClientInterface>(
    () =>
        HttpClientImpl(environmentConfig: getIt<EnvironmentConfigInterface>()),
  );

  getIt.registerLazySingleton<TransactionGateway>(
    () => TransactionApi(httpClient: getIt<HttpClientInterface>()),
  );

  getIt.registerSingleton<GetTransactionsUseCase>(
    GetTransactionsUseCase(transactionGateway: getIt<TransactionGateway>())
      ..call(),
  );
}
