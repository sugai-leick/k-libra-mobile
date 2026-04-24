import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/features/sales/presentation/bloc/sales_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController = TextEditingController(
    text: '0,00',
  );
  final TextEditingController _qtyController = TextEditingController(text: '1');

  @override
  void dispose() {
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SalesFormBloc>(
      create: (context) => sl<SalesFormBloc>(),
      child: BlocConsumer<SalesFormBloc, SalesFormState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Venda registrada com sucesso!')),
            );
            Navigator.pop(context);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<SalesFormBloc>();

          return Scaffold(
            backgroundColor: const Color(0xFF0D0D0E),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Novo Pedido',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('DADOS DO CLIENTE / ALUNO'),
                    const SizedBox(height: 16),
                    _buildCard([_buildStudentSearch(bloc, state)]),

                    const SizedBox(height: 24),
                    _buildSectionTitle('DADOS DA OFERTA'),
                    const SizedBox(height: 16),
                    _buildCard([
                      _buildDropdownField(
                        label: 'Tipo de Oferta',
                        value: state.saleType,
                        items: const [
                          DropdownMenuItem(
                            value: 'course',
                            child: Text('📚 Curso'),
                          ),
                          DropdownMenuItem(
                            value: 'hardware',
                            child: Text('⚙️ Hardware / Ativo'),
                          ),
                          DropdownMenuItem(
                            value: 'consumable',
                            child: Text('📦 Insumo / Consumível'),
                          ),
                        ],
                        onChanged: (val) =>
                            bloc.add(ChangeSaleTypeEvent(val ?? 'course')),
                      ),
                      _buildDivider(),
                      _buildDynamicItemSelector(bloc, state),
                      if (state.saleType == 'course') ...[
                        _buildDivider(),
                        _buildDropdownField(
                          label: 'Tipo de Plano',
                          value: state.planType,
                          items: const [
                            DropdownMenuItem(
                              value: 'base',
                              child: Text('Básico'),
                            ),
                            DropdownMenuItem(
                              value: 'pro',
                              child: Text('Professional'),
                            ),
                          ],
                          onChanged: (val) =>
                              bloc.add(ChangePlanTypeEvent(val ?? 'base')),
                        ),
                      ],
                    ]),

                    const SizedBox(height: 24),
                    _buildSectionTitle('FINANCEIRO'),
                    const SizedBox(height: 16),
                    _buildCard([
                      _buildTextField(
                        label: 'Preço Unitário (R\$)',
                        controller: _priceController,
                        icon: Icons.local_offer_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        onChanged: (val) {
                          final price = _parseCurrency(val);
                          bloc.add(ChangeFinancialEvent(valor: price));
                        },
                      ),
                      _buildDivider(),
                      _buildTextField(
                        label: 'Quantidade',
                        controller: _qtyController,
                        icon: Icons.layers_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final qty = int.tryParse(val) ?? 1;
                          bloc.add(ChangeFinancialEvent(quantidade: qty));
                        },
                      ),
                    ]),

                    const SizedBox(height: 24),
                    _buildTotalDisplay(state.valor * state.quantidade),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('ENDEREÇO DE ENTREGA'),
                        Row(
                          children: [
                            Text(
                              'Outro endereço?',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: state.useDifferentAddress,
                                onChanged: (val) =>
                                    bloc.add(ToggleDifferentAddressEvent(val)),
                                activeThumbColor: AppColors.accentPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.useDifferentAddress)
                      _buildCard([
                            _buildTextField(
                              label: 'Nome do Destinatário',
                              icon: Icons.person_outline,
                              onChanged: (val) =>
                                  bloc.add(ChangeAddressEvent(nome: val)),
                            ),
                            _buildDivider(),
                            _buildTextField(
                              label: 'CEP',
                              icon: Icons.map_outlined,
                              keyboardType: TextInputType.number,
                              onChanged: (val) =>
                                  bloc.add(ChangeAddressEvent(cep: val)),
                            ),
                            _buildDivider(),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildTextField(
                                    label: 'Rua',
                                    onChanged: (val) =>
                                        bloc.add(ChangeAddressEvent(rua: val)),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Nº',
                                    onChanged: (val) => bloc.add(
                                      ChangeAddressEvent(numero: val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.2, curve: Curves.easeOutQuad),

                    const SizedBox(height: 40),
                    _buildSubmitButton(bloc, state),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicItemSelector(SalesFormBloc bloc, SalesFormState state) {
    String label = 'Item';
    List<DropdownMenuItem<String>> items = [];

    if (state.saleType == 'course') {
      label = 'Selecionar Curso';
      items = const [
        DropdownMenuItem(
          value: 'course_1',
          child: Text('🎓 Expert em Reabilitação'),
        ),
        DropdownMenuItem(
          value: 'course_2',
          child: Text('🎓 Master em Oclusão'),
        ),
        DropdownMenuItem(value: 'course_3', child: Text('🎓 Imersão Digital')),
      ];
    } else if (state.saleType == 'hardware') {
      label = 'Selecionar Equipamento';
      items = const [
        DropdownMenuItem(
          value: 'hw_1',
          child: Text('⚙️ Scanner Intraoral Libra'),
        ),
        DropdownMenuItem(value: 'hw_2', child: Text('⚙️ Sensor T-Scan Pro')),
      ];
    } else {
      label = 'Selecionar Insumo';
      items = const [
        DropdownMenuItem(value: 'ins_1', child: Text('📦 Resina 3D Premium')),
        DropdownMenuItem(value: 'ins_2', child: Text('📦 Spray Oclusal')),
      ];
    }

    return _buildDropdownField(
      label: label,
      value: state.selectedItemId,
      items: items,
      onChanged: (val) => bloc.add(ChangeSelectedItemEvent(itemId: val)),
    );
  }

  double _parseCurrency(String val) {
    if (val.isEmpty) return 0.0;
    final clean = val.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(clean) ?? 0.0;
  }

  Widget _buildStudentSearch(SalesFormBloc bloc, SalesFormState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aluno',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Autocomplete<String>(
            optionsBuilder: (val) => state.students
                .where(
                  (s) => s.nomeCompleto.toLowerCase().contains(
                    val.text.toLowerCase(),
                  ),
                )
                .map((s) => s.nomeCompleto),
            onSelected: (val) {
              final student = state.students.firstWhere(
                (s) => s.nomeCompleto == val,
              );
              bloc.add(ChangeSelectedStudentEvent(student.id));
            },
            fieldViewBuilder: (context, controller, focus, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focus,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar aluno...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  suffixIcon: state.isLoadingStudents
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search, size: 18),
                  border: InputBorder.none,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(SalesFormBloc bloc, SalesFormState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isSubmitting
            ? null
            : () => bloc.add(SubmitSaleEvent()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'GERAR PEDIDO',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.white.withValues(alpha: 0.3),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, color: Colors.white.withValues(alpha: 0.05));

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              prefixIcon: icon != null
                  ? Icon(icon, size: 18, color: AppColors.accentPurple)
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.any((i) => i.value == value) ? value : null,
              items: items,
              onChanged: onChanged,
              dropdownColor: const Color(0xFF161618),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay(double total) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentPurple.withValues(alpha: 0.2),
            AppColors.accentPurple.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'VALOR TOTAL',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Text(
            formatter.format(total),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) return newValue;
    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) return newValue.copyWith(text: "0,00");
    double value = double.parse(cleanText);
    final formatter = NumberFormat.currency(locale: "pt_BR", symbol: "");
    String newText = formatter.format(value / 100).trim();
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
