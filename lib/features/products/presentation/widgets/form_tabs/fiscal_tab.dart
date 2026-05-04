import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_helpers.dart';

class FiscalTab extends StatelessWidget {
  final TextEditingController ncmController;
  final TextEditingController cfopController;
  final String origemFiscalSelecionada;
  final Function(String) onOrigemChanged;

  const FiscalTab({
    super.key,
    required this.ncmController,
    required this.cfopController,
    required this.origemFiscalSelecionada,
    required this.onOrigemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('fiscal'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFormLabel('Código NCM'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: ncmController,
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: formInputDecoration('0000.00.00'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFormLabel('CFOP Padrão'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: cfopController,
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: formInputDecoration('5102'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildFormLabel('Origem da Mercadoria'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: origemFiscalSelecionada,
              isExpanded: true,
              dropdownColor: AppColors.cardDark,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
              items: const [
                DropdownMenuItem(value: '0', child: Text('0 - Nacional')),
                DropdownMenuItem(
                  value: '1',
                  child: Text('1 - Estrangeira (Direta)'),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Text('2 - Estrangeira (Mercado Interno)'),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Text('3 - Nacional (Imp > 40%)'),
                ),
              ],
              onChanged: (v) => onOrigemChanged(v ?? '0'),
            ),
          ),
        ),
      ],
    );
  }
}
