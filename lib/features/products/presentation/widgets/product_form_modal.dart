import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/presentation/widgets/dtos/product_dto.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/geral_tab.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/fiscal_tab.dart';
import 'package:flutter_app/features/products/presentation/widgets/form_tabs/variantes_tab.dart';

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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderDark)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.layers_rounded,
                            color: AppColors.primaryDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cadastrar Novo Item',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tabs
                Row(
                  children: [
                    _buildTab(0, 'Geral', Icons.inventory_2_rounded),
                    const SizedBox(width: 8),
                    _buildTab(1, 'Fiscal', Icons.description_rounded),
                    const SizedBox(width: 8),
                    _buildTab(2, 'Variantes', Icons.sell_rounded),
                  ],
                ),
              ],
            ),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderDark)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Descartar',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Cadastrar na Nuvem',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
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

  Widget _buildTab(int index, String title, IconData icon) {
    final isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
