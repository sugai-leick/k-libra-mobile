import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/products_dropdown.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/add_inventory_modal/inventory_form_field.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/add_inventory_modal/variants_dropdown.dart';

class HardwareInventoryForm extends StatelessWidget {
  final Product? selectedProduct;
  final Function(Product) onProductSelected;
  final List<ProductVariant> availableVariants;
  final ProductVariant? selectedVariant;
  final Function(ProductVariant) onVariantSelected;
  final TextEditingController serialController;

  const HardwareInventoryForm({
    super.key,
    required this.selectedProduct,
    required this.onProductSelected,
    required this.availableVariants,
    required this.selectedVariant,
    required this.onVariantSelected,
    required this.serialController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductsDropdown(
          filterType: 'hardware',
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
                    'Este hardware não possui variantes cadastradas e não pode ser registrado.',
                    style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        InventoryFormField(
          label: 'Número de Série',
          controller: serialController,
          icon: LucideIcons.barcode,
          placeholder: 'Ex: SN123456789',
        ),
      ],
    );
  }
}
