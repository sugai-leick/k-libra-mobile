import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/features/financial/financial.dart';
import 'package:intl/intl.dart';

class StrategicFinancialPage extends StatefulWidget {
  const StrategicFinancialPage({super.key});

  @override
  State<StrategicFinancialPage> createState() => _StrategicFinancialPageState();
}

class _StrategicFinancialPageState extends State<StrategicFinancialPage> {
  late String _from;
  late String _to;
  String _regime = 'cash'; // 'cash' or 'accrual'

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateFormat('yyyy-MM-01').format(now);
    _to = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));

    _fetchData();
  }

  void _fetchData() {
    context.read<StrategicFinancialBloc>().add(
          FetchStrategicDataRequested(
            from: _from,
            to: _to,
            regime: _regime,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<StrategicFinancialBloc, StrategicFinancialState>(
        builder: (context, state) {
          DreEntity? dre;
          bool isLoading = state is StrategicFinancialLoading;

          if (state is StrategicFinancialLoaded) {
            dre = state.dre;
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ModuleHeader(
                      title: 'Finanças Estratégicas',
                      subtitle: 'Demonstrativo de Resultados (DRE) e análise de margem.',
                      buttonLabel: 'Exportar PDF',
                      onButtonPressed: () {},
                    ),
                    StrategicFinancialFilters(
                      from: _from,
                      to: _to,
                      regime: _regime,
                      onDateRangeChanged: (newFrom, newTo) {
                        setState(() {
                          _from = newFrom;
                          _to = newTo;
                        });
                        _fetchData();
                      },
                      onRegimeToggled: () {
                        setState(() {
                          _regime = _regime == 'cash' ? 'accrual' : 'cash';
                        });
                        _fetchData();
                      },
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: FinancialDataQualityBanner(
                    metadata: dre?.metadata,
                    isLoading: isLoading,
                    from: _from,
                    onJump: (newFrom, newTo) {
                      setState(() {
                        _from = newFrom;
                        _to = newTo;
                      });
                      _fetchData();
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              if (state is StrategicFinancialError)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                )
              else
                StrategicFinancialDreList(dre: dre, isLoading: isLoading),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}

