import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/products_dropdown.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/add_inventory_modal/inventory_form_field.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/add_inventory_modal/variants_dropdown.dart';

class ConsumableInventoryForm extends StatelessWidget {
  final Product? selectedProduct;
  final Function(Product) onProductSelected;
  final List<ProductVariant> availableVariants;
  final ProductVariant? selectedVariant;
  final Function(ProductVariant) onVariantSelected;
  final TextEditingController quantityController;
  final String transactionType;
  final Function(String) onTypeChanged;

  const ConsumableInventoryForm({
    super.key,
    required this.selectedProduct,
    required this.onProductSelected,
    required this.availableVariants,
    required this.selectedVariant,
    required this.onVariantSelected,
    required this.quantityController,
    required this.transactionType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductsDropdown(
          filterType: 'consumivel',
          value: selectedProduct,
          onSelected: onProductSelected,
        ),
        if (availableVariants.isNotEmpty) ...[
          const SizedBox(height: 20),
          VariantsDropdown(
            variants: availableVariants,
            value: selectedVariant,
            onSelected: onVariantSelected,
          ),
        ] else if (selectedProduct != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.info, color: Colors.redAccent, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Este produto não possui variantes cadastradas no sistema e não pode ser movimentado.',
                    style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: InventoryFormField(
                label: 'Quantidade',
                controller: quantityController,
                icon: LucideIcons.hash,
                keyboardType: TextInputType.number,
                placeholder: '0',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operação',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: transactionType,
                    dropdownColor: AppColors.cardDark,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                      DropdownMenuItem(value: 'saida', child: Text('Saída')),
                    ],
                    onChanged: (val) => onTypeChanged(val ?? 'entrada'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
