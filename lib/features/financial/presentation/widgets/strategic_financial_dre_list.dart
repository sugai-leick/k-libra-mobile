import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

class StrategicFinancialDreList extends StatelessWidget {
  final DreEntity? dre;
  final bool isLoading;

  const StrategicFinancialDreList({
    super.key,
    required this.dre,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (dre == null && isLoading) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (dre == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final data = dre!;

    final rows = [
      _DreRowData(label: 'Receita Bruta', value: data.revenue, isHeader: true),
      _DreRowData(label: '(-) Deduções e Impostos', value: data.deductions, isHeader: false),
      _DreRowData(label: 'Receita Líquida', value: data.netRevenue, isDivider: true),
      _DreRowData(label: '(-) Custos (CPV)', value: data.cogs, isHeader: false),
      _DreRowData(label: 'Lucro Bruto', value: data.grossProfit, isDivider: true),
      _DreRowData(label: '(-) Despesas Operacionais', value: data.opex, isHeader: false),
      _DreRowData(
        label: 'Resultado Líquido (EBITDA)',
        value: data.netIncome,
        isHeader: true,
        color: data.netIncome >= 0 ? AppColors.success : Colors.redAccent,
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return _buildDreRow(row)
                .animate()
                .fadeIn(delay: (50 * index).ms)
                .moveX(begin: -10, end: 0);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDreRow(_DreRowData row) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: row.isDivider
            ? Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1))
            : null,
        color: row.isHeader ? Colors.white.withValues(alpha: 0.03) : null,
        borderRadius: row.isHeader ? BorderRadius.circular(12) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.label,
            style: GoogleFonts.inter(
              fontSize: row.isHeader ? 14 : 13,
              fontWeight: row.isHeader ? FontWeight.w900 : FontWeight.w500,
              color: row.isHeader ? Colors.white : Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Text(
            NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(row.value),
            style: GoogleFonts.inter(
              fontSize: row.isHeader ? 14 : 13,
              fontWeight: FontWeight.bold,
              color: row.color ?? (row.value < 0 ? Colors.redAccent : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DreRowData {
  final String label;
  final double value;
  final bool isHeader;
  final bool isDivider;
  final Color? color;

  _DreRowData({
    required this.label,
    required this.value,
    this.isHeader = false,
    this.isDivider = false,
    this.color,
  });
}
