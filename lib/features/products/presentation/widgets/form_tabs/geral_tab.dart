import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_helpers.dart';

class GeralTab extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController descricaoController;
  final String tipoSelecionado;
  final Function(String) onTipoChanged;

  const GeralTab({
    super.key,
    required this.nomeController,
    required this.descricaoController,
    required this.tipoSelecionado,
    required this.onTipoChanged,
  });

  Widget _buildTypeOption(String value, String title, IconData icon, Color color) {
    final isActive = tipoSelecionado == value;
    return GestureDetector(
      onTap: () => onTipoChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.5)
                : AppColors.borderDark,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isActive ? color : Colors.white54),
            const SizedBox(height: 6),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isActive ? color : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('geral'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFormLabel('Nome do Produto *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: nomeController,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          decoration: formInputDecoration('Ex: Resina Premium Plus'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Nome é obrigatório' : null,
        ),
        const SizedBox(height: 20),
        buildFormLabel('Tipo de Categoria'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                'hardware',
                'Hardware',
                Icons.memory_rounded,
                Colors.purpleAccent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTypeOption(
                'consumivel',
                'Consumível',
                Icons.shopping_bag_rounded,
                Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTypeOption(
                'insumo',
                'Insumo',
                Icons.science_rounded,
                Colors.greenAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildFormLabel('Descrição Comercial'),
        const SizedBox(height: 8),
        TextFormField(
          controller: descricaoController,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          decoration: formInputDecoration('Descrição para orçamentos...'),
        ),
      ],
    );
  }
}
