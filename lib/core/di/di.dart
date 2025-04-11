import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mejoralo_cdt/features/dashboard/presentation/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:mejoralo_cdt/features/dashboard/presentation/widgets/edge_chat/cubit/chart_cubit.dart';

import '../../common/common.dart';
import '../../features/dashboard/infrastructure/infrastructure.dart';
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

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  getIt.registerLazySingleton<TransactionGateway>(
    () => TransactionApiCacheDecorator(
      TransactionApi(httpClient: getIt<HttpClientInterface>()),
      connectivity: getIt<Connectivity>(),
    ),
  );
  getIt.registerLazySingleton<GetTransactionsUseCase>(
    () =>
        GetTransactionsUseCase(transactionGateway: getIt<TransactionGateway>()),
  );

  getIt.registerLazySingleton<DashboardCubit>(
    () =>
        DashboardCubit(getTransactionsUseCase: getIt<GetTransactionsUseCase>()),
  );

  getIt.registerLazySingleton<ChartCubit>(() => ChartCubit());
}
