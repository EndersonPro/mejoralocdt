import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mejoralo_cdt/features/dashboard/presentation/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:mejoralo_cdt/features/dashboard/presentation/widgets/edge_chat/cubit/chart_cubit.dart';
import 'package:mejoralo_cdt/ui/shared/theme/theme.dart';

import 'core/core.dart';
import 'features/features.dart';

class MejoraloCDTApp extends StatelessWidget {
  const MejoraloCDTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<DashboardCubit>()..getTransactions(),
          ),
          BlocProvider(create: (context) => getIt<ChartCubit>()),
        ],
        child: DashboardPage(),
      ),
      theme: AppThemes.lightTheme(),
    );
  }
}
