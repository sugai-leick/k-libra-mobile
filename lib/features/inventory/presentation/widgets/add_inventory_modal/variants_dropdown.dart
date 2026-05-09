import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';

class VariantsDropdown extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant? value;
  final Function(ProductVariant) onSelected;
  final bool isLoading;

  const VariantsDropdown({
    super.key,
    required this.variants,
    required this.value,
    required this.onSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variante / Cor',
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ProductVariant>(
          value: value,
          dropdownColor: AppColors.cardDark,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: isLoading ? 'Carregando variantes...' : 'Selecione a variante',
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
            prefixIcon: const Icon(LucideIcons.layers, color: Colors.white24, size: 18),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: variants.map((variant) {
            final label = variant.cor != null && variant.atributo != null
                ? '${variant.nome} (${variant.cor} - ${variant.atributo})'
                : variant.cor != null
                    ? '${variant.nome} (${variant.cor})'
                    : variant.atributo != null
                        ? '${variant.nome} (${variant.atributo})'
                        : variant.nome;
            
            return DropdownMenuItem(
              value: variant,
              child: Text(label, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onSelected(val);
          },
          validator: (val) => val == null ? 'Selecione uma variante' : null,
        ),
      ],
    );
  }
}
