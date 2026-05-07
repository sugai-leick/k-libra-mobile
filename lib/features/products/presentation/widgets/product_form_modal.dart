import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/presentation/widgets/dtos/product_dto.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/geral_tab.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/fiscal_tab.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/variantes_tab.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_header.dart';
import 'package:flutter_app/features/products/presentation/widgets/product_form_footer.dart';
class ProductFormModal extends StatefulWidget {
  final Function(ProductDto) onSave;

  const ProductFormModal({super.key, required this.onSave});

  static Future<void> show(
    BuildContext context, {
    required Function(ProductDto) onSave,
  }) {
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
              child: ProductFormModal(onSave: onSave),
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
  State<ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModal> {
  int _activeTab = 0; // 0: Geral, 1: Fiscal, 2: Variantes
  final _formKey = GlobalKey<FormState>();

  // Geral
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _tipo = 'consumivel';

  // Fiscal
  final _ncmController = TextEditingController();
  final _cfopController = TextEditingController();
  String _origemFiscal = '0';

  // Variantes
  final _varNomeController = TextEditingController();
  final _varCodigoController = TextEditingController();
  final List<ProductVariant> _variants = [];

  bool _isLoading = false;

  void _addVariant() {
    if (_varNomeController.text.isEmpty || _varCodigoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e Código são obrigatórios para a variante.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      _variants.add(
        ProductVariant(
          nome: _varNomeController.text,
          codigo: _varCodigoController.text,
          atributo: 'Variante',
        ),
      );
      _varNomeController.clear();
      _varCodigoController.clear();
    });
  }

  void _removeVariant(int index) {
    setState(() {
      _variants.removeAt(index);
    });
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final params = ProductDto(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      tipo: ProductType.values.firstWhere(
        (e) => e.name == _tipo,
        orElse: () => ProductType.consumivel,
      ),
      ncm: _ncmController.text,
      origemFiscal: _origemFiscal,
      cfopPadrao: _cfopController.text,
      requiresInvoice: true,
      variants: _variants,
    );

    try {
      await widget.onSave(params);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Header
          // Header
          ProductFormHeader(
            activeTab: _activeTab,
            onTabChanged: (index) => setState(() => _activeTab = index),
            onClose: () => Navigator.pop(context),
          ),

          // Content
          Flexible(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildActiveTabContent(),
                ),
              ),
            ),
          ),

          // Footer
          // Footer
          ProductFormFooter(
            isLoading: _isLoading,
            onCancel: () => Navigator.pop(context),
            onSubmit: _handleSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return GeralTab(
          nomeController: _nomeController,
          descricaoController: _descricaoController,
          tipoSelecionado: _tipo,
          onTipoChanged: (val) => setState(() => _tipo = val),
        );
      case 1:
        return FiscalTab(
          ncmController: _ncmController,
          cfopController: _cfopController,
          origemFiscalSelecionada: _origemFiscal,
          onOrigemChanged: (val) => setState(() => _origemFiscal = val),
        );
      case 2:
        return VariantesTab(
          varNomeController: _varNomeController,
          varCodigoController: _varCodigoController,
          variants: _variants,
          onAddVariant: _addVariant,
          onRemoveVariant: _removeVariant,
        );
      default:
        return const SizedBox.shrink();
    }
  }


}
