import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';

// Modal Sub-widgets
import 'add_inventory_modal/add_inventory_header.dart';
import 'add_inventory_modal/add_inventory_footer.dart';
import 'add_inventory_modal/inventory_type_selector.dart';
import 'add_inventory_modal/hardware_inventory_form.dart';
import 'add_inventory_modal/consumable_inventory_form.dart';

import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/inventory/presentation/bloc/products_list/bloc/products_list_bloc.dart';
import 'package:flutter_app/core/di/injection_container.dart';

class AddInventoryModal extends StatefulWidget {
  const AddInventoryModal({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: BlocProvider(
                create: (context) => sl<ProductsListBloc>()..add(ProductsListRequested()),
                child: const AddInventoryModal(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<AddInventoryModal> createState() => _AddInventoryModalState();
}

class _AddInventoryModalState extends State<AddInventoryModal> {
  final _formKey = GlobalKey<FormState>();
  bool _isHardware = true;
  Product? _selectedProduct;
  ProductVariant? _selectedVariant;

  final _serialNumController = TextEditingController();
  final _quantityController = TextEditingController();
  String _transactionType = 'entrada';

  @override
  void dispose() {
    _serialNumController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedProduct == null) return;

      // 🔥 CRITICAL FIX: The backend repository REQUIRES a variant_id.
      // If no variant is selected (or available), we must prevent submission to avoid 500 error.
      if (_selectedVariant == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione uma variante/cor para prosseguir.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      if (_isHardware) {
        final dto = AddHardwareDto(
          productSk: _selectedProduct!.productSk,
          productId: _selectedProduct!.productId,
          variantId: _selectedVariant!.id,
          serialNumber: _serialNumController.text,
        );
        context.read<InventoryBloc>().add(AddHardwareEvent(dto));
      } else {
        final dto = InventoryTransactionDto(
          productSk: _selectedProduct!.productSk,
          productId: _selectedProduct!.productId,
          variantId: _selectedVariant!.id,
          quantity: int.tryParse(_quantityController.text) ?? 0,
          type: _transactionType,
          referenceType: 'manual',
        );
        context.read<InventoryBloc>().add(RegisterTransactionEvent(dto));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsListBloc, ProductsListState>(
      builder: (context, state) {
        List<ProductVariant> availableVariants = [];
        if (state is ProductsListLoaded && _selectedProduct != null) {
          availableVariants = state.variantList
              .where((v) => v.productSk == _selectedProduct!.productSk)
              .toList();
        }

        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderDark),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AddInventoryHeader(onClose: () => Navigator.pop(context)),
              Flexible(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        InventoryTypeSelector(
                          isHardware: _isHardware,
                          onTypeChanged: (val) => setState(() {
                            _isHardware = val;
                            _selectedProduct = null;
                            _selectedVariant = null;
                          }),
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: AppColors.borderDark, height: 1),
                        const SizedBox(height: 24),
                        _isHardware
                            ? HardwareInventoryForm(
                                selectedProduct: _selectedProduct,
                                onProductSelected: (Product p) => setState(() {
                                  _selectedProduct = p;
                                  _selectedVariant = null;
                                }),
                                availableVariants: availableVariants,
                                selectedVariant: _selectedVariant,
                                onVariantSelected: (v) => setState(() => _selectedVariant = v),
                                serialController: _serialNumController,
                              )
                            : ConsumableInventoryForm(
                                selectedProduct: _selectedProduct,
                                onProductSelected: (Product p) => setState(() {
                                  _selectedProduct = p;
                                  _selectedVariant = null;
                                }),
                                availableVariants: availableVariants,
                                selectedVariant: _selectedVariant,
                                onVariantSelected: (v) => setState(() => _selectedVariant = v),
                                quantityController: _quantityController,
                                transactionType: _transactionType,
                                onTypeChanged: (val) => setState(() => _transactionType = val),
                              ) as Widget,
                      ],
                    ),
                  ),
                ),
              ),
              AddInventoryFooter(
                onCancel: () => Navigator.pop(context),
                onSubmit: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
