import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/shared/module_header.dart';
import 'package:flutter_app/core/widgets/shared/stat_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ConciliationPage extends StatelessWidget {
  const ConciliationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ModuleHeader(
            title: 'Conciliação',
            subtitle: 'Conferência entre registros do sistema e extrato bancário.',
            buttonLabel: 'Importar OFX',
            buttonIcon: Icons.cloud_upload_rounded,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Pendente',
                    value: '12',
                    icon: Icons.history_toggle_off_rounded,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'Divergência',
                    value: '03',
                    icon: Icons.error_outline_rounded,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  _buildComparisonRow('Saldo Sistema', 'R\$ 142.500,00', AppColors.accentBlue),
                  const Divider(color: Colors.white10, height: 32),
                  _buildComparisonRow('Saldo Bancário', 'R\$ 142.200,00', Colors.amber),
                  const Divider(color: Colors.white10, height: 32),
                  _buildComparisonRow('Diferença', 'R\$ 300,00', Colors.redAccent, isBold: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ÚLTIMOS LANÇAMENTOS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTransactionTile('Venda #9923', 'Itau Unibanco', 'R\$ 1.200,00', true),
                _buildTransactionTile('Pix Recebido', 'Santander', 'R\$ 450,00', true),
                _buildTransactionTile('Pgto Fornecedor', 'Inter', 'R\$ -890,00', false),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(String title, String bank, String value, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : Colors.redAccent).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPositive ? Icons.south_west_rounded : Icons.north_east_rounded,
                  color: isPositive ? AppColors.success : Colors.redAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    bank,
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isPositive ? AppColors.success : Colors.redAccent,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.05, end: 0);
  }
}
