import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/core/theme/app_colors.dart';

class StrategicFinancialFilters extends StatelessWidget {
  final String from;
  final String to;
  final String regime;
  final Function(String, String) onDateRangeChanged;
  final VoidCallback onRegimeToggled;

  const StrategicFinancialFilters({
    super.key,
    required this.from,
    required this.to,
    required this.regime,
    required this.onDateRangeChanged,
    required this.onRegimeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterCard(
                  context: context,
                  label: 'PERÍODO',
                  value: '${DateFormat('dd/MM').format(DateTime.parse(from))} - ${DateFormat('dd/MM').format(DateTime.parse(to))}',
                  icon: Icons.calendar_today_rounded,
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      initialDateRange: DateTimeRange(
                        start: DateTime.parse(from),
                        end: DateTime.parse(to),
                      ),
                    );
                    if (picked != null) {
                      onDateRangeChanged(
                        DateFormat('yyyy-MM-dd').format(picked.start),
                        DateFormat('yyyy-MM-dd').format(picked.end),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterCard(
                  context: context,
                  label: 'REGIME',
                  value: regime == 'cash' ? 'CAIXA' : 'COMPETÊNCIA',
                  icon: Icons.account_balance_wallet_rounded,
                  onTap: onRegimeToggled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.accentPurple),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
