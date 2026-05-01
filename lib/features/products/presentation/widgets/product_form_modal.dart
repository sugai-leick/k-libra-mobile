import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/products/presentation/widgets/dtos/product_dto.dart';

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
        return _buildGeralTab();
      case 1:
        return _buildFiscalTab();
      case 2:
        return _buildVariantesTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGeralTab() {
    return Column(
      key: const ValueKey('geral'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nome do Produto *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nomeController,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          decoration: _inputDecoration('Ex: Resina Premium Plus'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Nome é obrigatório' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('Tipo de Categoria'),
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
        _buildLabel('Descrição Comercial'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descricaoController,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          decoration: _inputDecoration('Descrição para orçamentos...'),
        ),
      ],
    );
  }

  Widget _buildFiscalTab() {
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
                  _buildLabel('Código NCM'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ncmController,
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: _inputDecoration('0000.00.00'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('CFOP Padrão'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cfopController,
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: _inputDecoration('5102'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildLabel('Origem da Mercadoria'),
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
              value: _origemFiscal,
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
              onChanged: (v) => setState(() => _origemFiscal = v ?? '0'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantesTab() {
    return Column(
      key: const ValueKey('variantes'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADICIONAR SUBTIPO',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _varNomeController,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration('Nome (Ex: Azul)').copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _varCodigoController,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration('Cód. Ref.').copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addVariant,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    'Incluir Variante',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'SUBTIPOS CADASTRADOS (${_variants.length})',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (_variants.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.borderDark,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Nenhum subtipo adicionado (Produto Único)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white38,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _variants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final variant = _variants[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.sell_rounded,
                        color: AppColors.primaryDark,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            variant.nome.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Cód: ${variant.codigo}',
                            style: GoogleFonts.robotoMono(
                              fontSize: 10,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      onPressed: () => _removeVariant(index),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildTypeOption(
    String value,
    String title,
    IconData icon,
    Color color,
  ) {
    final isActive = _tipo == value;
    return GestureDetector(
      onTap: () => setState(() => _tipo = value),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryDark),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
