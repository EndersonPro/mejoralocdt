import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mejoralo_cdt/core/core.dart';
import 'package:mejoralo_cdt/ui/shared/card.dart';
import 'package:mejoralo_cdt/ui/shared/shimmer.dart';
import 'package:mejoralo_cdt/ui/shared/theme/colors.dart';

import '../../widgets/edge_chat/cubit/chart_cubit.dart';
import '../../widgets/edge_chat/edge_chart.dart';
import '../../widgets/title_info.dart';
import 'cubit/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().isConnectedToInternet.listen((state) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(state ? Icons.wifi : Icons.wifi_off, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                state
                    ? 'Conexión a internet restablecida'
                    : 'Sin conexión a internet',
              ),
            ],
          ),
          backgroundColor: state ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void dispose() {
    context.read<DashboardCubit>().closeConnectionToStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFetchingData = context.select(
      (DashboardCubit cubit) => cubit.state.isFetchingData,
    );

    final totalInvestment = context.select(
      (DashboardCubit cubit) => cubit.state.totalInvestment,
    );

    final averageROI = context.select(
      (DashboardCubit cubit) => cubit.state.averageROI,
    );

    final totalProfit = context.select(
      (DashboardCubit cubit) => cubit.state.totalProfit,
    );

    final transactions = context.select(
      (DashboardCubit cubit) => cubit.state.transactions,
    );

    final yearsToFilter = context.select(
      (DashboardCubit cubit) => cubit.state.years,
    );

    final yearFilterSelected = context.select(
      (ChartCubit cubit) => cubit.state.yearFilterSelected,
    );

    final height = MediaQuery.sizeOf(context).height;

    final transactionByBank = context
        .read<DashboardCubit>()
        .groupTransactionsByBank(transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MejoraloCDT',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return context.read<DashboardCubit>().getTransactions();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  MShimmer(
                    isLoading: isFetchingData,
                    child: MCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleInfo(
                            title: "Inversion Total",
                            subTitle: totalInvestment.toCurrencyWithSymbol(
                              "COP",
                            ),
                          ),
                          TitleInfo(
                            title: "ROI Promedio",
                            subTitle: averageROI.toPercentage(),
                            useTooltip: true,
                            tooltipMessage:
                                "El ROI promedio es el retorno de la inversión promedio de los proyectos en los que has invertido.",
                          ),
                        ],
                      ),
                    ),
                  ),
                  MShimmer(
                    isLoading: isFetchingData,
                    child: MCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleInfo(
                                title: "Rendimiento Total",
                                subTitle: totalProfit.toCurrencyWithSymbol(
                                  "COP",
                                ),
                                useTooltip: true,
                                tooltipMessage:
                                    "El rendimiento total es la suma de los rendimientos de todos los proyectos en los que has invertido.",
                              ),
                              const SizedBox(width: 10),
                              DropdownButton(
                                value: yearFilterSelected,
                                items:
                                    yearsToFilter
                                        .map(
                                          (year) => DropdownMenuItem(
                                            value: year,
                                            child: Text(year),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  context
                                      .read<ChartCubit>()
                                      .setYearFilterSelected(value);
                                },
                                borderRadius: BorderRadius.circular(6),
                              ),
                              // DropdownButton(
                              //   value: 1,
                              //   items: List.generate(
                              //     3,
                              //     (index) => DropdownMenuItem(
                              //       value: index,
                              //       child: Text('Año'),
                              //     ),
                              //   ),
                              //   onChanged: (value) {
                              //     // Handle dropdown change
                              //   },

                              //   borderRadius: BorderRadius.circular(6),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: height * .2,
                            width: double.infinity,
                            // color: Colors.red,
                            child: EdgeChart(transactions: transactions),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MShimmer(
                    isLoading: isFetchingData,
                    child: MCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleInfo(
                                title: "Distribucion por Bancos",
                                // subTitle: totalProfit.toCurrencyWithSymbol("COP"),
                                useTooltip: true,
                                tooltipMessage:
                                    "La distribucion por bancos es la suma de los rendimientos de todos los proyectos en los que has invertido.",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: height * .2,
                            width: double.infinity,
                            // color: Colors.red,
                            child: ListView.builder(
                              itemCount: transactionByBank.length,
                              itemBuilder: (context, index) {
                                final data = transactionByBank[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.bankName,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              data.transactionCount > 1
                                                  ? "${data.transactionCount.toString()} CDTs activos"
                                                  : "${data.transactionCount.toString()} CDT activo",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          data.totalAmount.toCurrencyWithSymbol(
                                            "COP",
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  MShimmer(
                    isLoading: isFetchingData,
                    child: MCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleInfo(
                                title: "Mis CDTs (${transactions.length})",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: height * .2,
                            width: double.infinity,
                            // color: Colors.red,
                            child: ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final data = transactions[index];

                                final startDate = parseFormattedDate(
                                  data.startDate,
                                );

                                final endDate = parseFormattedDate(
                                  data.endDate,
                                );

                                final elapsedTime =
                                    DateTime.now().difference(startDate).inDays;

                                final termDaysTime =
                                    endDate.difference(DateTime.now()).inDays;

                                // Calculate days remaining based on term days
                                final int daysRemaining =
                                    termDaysTime - elapsedTime;
                                final bool isExpired = daysRemaining <= 0;
                                final bool isAboutToExpire =
                                    daysRemaining > 0 && daysRemaining <= 30;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          isExpired
                                              ? AppColors.errorColor
                                              // ignore: deprecated_member_use
                                              .withOpacity(0.2)
                                              : AppColors.surfaceColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.bankName,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Tiempo transcurrido ${elapsedTime.toString()}",
                                            ),
                                            if (isAboutToExpire)
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (
                                                          context,
                                                        ) => AlertDialog(
                                                          title: const Text(
                                                            'CDT próximo a vencer',
                                                          ),
                                                          content: const Text(
                                                            '¿Qué acción desea tomar con este CDT?',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                              child: const Text(
                                                                'Renovar',
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                              child: const Text(
                                                                'Retirar',
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                              child: const Text(
                                                                'Cancelar',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  );
                                                },
                                                child: Text(
                                                  "Está próximo a vencer, ¿Qué desea hacer?",
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          data.amount.toCurrencyWithSymbol(
                                            "COP",
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
