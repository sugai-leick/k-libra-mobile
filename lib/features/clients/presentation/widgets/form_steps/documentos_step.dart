import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/presentation/widgets/custom_form_field.dart';

class DocumentosStep extends StatefulWidget {
  const DocumentosStep({super.key});

  @override
  State<DocumentosStep> createState() => _DocumentosStepState();
}

class _DocumentosStepState extends State<DocumentosStep> {
  late TextEditingController _cpfController;
  late TextEditingController _cnpjController;
  late TextEditingController _dataNascimentoController;

  String? _cpfError;
  String? _dataNascimentoError;

  @override
  void initState() {
    super.initState();
    final dto = context.read<FormularioClientesBloc>().state.clientDto;
    _cpfController = TextEditingController(text: dto.cpf ?? '');
    _cnpjController = TextEditingController(text: dto.cnpj ?? '');
    _dataNascimentoController = TextEditingController(
      text: dto.dataNascimento ?? '',
    );
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _cnpjController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppColors.accentBlue;
    final surfaceColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final onSurfaceColor = isDark
        ? AppColors.foregroundDark
        : AppColors.foregroundLight;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1980, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: surfaceColor,
              onSurface: onSurfaceColor,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: surfaceColor,
              headerBackgroundColor: AppColors.accentPurple,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return onSurfaceColor;
              }),
              todayForegroundColor: WidgetStateProperty.all(
                AppColors.primaryDark,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dataNascimentoController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documentos Principais',
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 8),
          Text(
            'Informe CPF/CNPJ e a data de nascimento.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ).animate().fadeIn(delay: 100.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 32),

          CustomFormField(
            controller: _cpfController,
            hint: 'CPF *',
            icon: LucideIcons.fileText,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            errorText: _cpfError,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _cnpjController,
            hint: 'CNPJ (opcional)',
            icon: LucideIcons.building,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CnpjInputFormatter(),
            ],
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _dataNascimentoController,
            hint: 'Data de Nascimento (DD/MM/AAAA) *',
            icon: LucideIcons.calendar,
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            errorText: _dataNascimentoError,
            suffixIcon: IconButton(
              icon: const Icon(LucideIcons.calendarDays, size: 20),
              onPressed: () => _selectDate(context),
              color: AppColors.accentBlue,
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 48),

          Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          final bloc = context.read<FormularioClientesBloc>();
                          final atualDto = bloc.state.clientDto;
                          bloc.add(
                            VoltarEtapaEvent(
                              clientDto: atualDto.copyWith(
                                cpf: _cpfController.text,
                                cnpj: _cnpjController.text,
                                dataNascimento: _dataNascimentoController.text,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.accentBlue.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final cpf = _cpfController.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (cpf.isEmpty) {
                              _cpfError = 'CPF é obrigatório';
                            } else if (cpf.length < 11) {
                              _cpfError = 'CPF incompleto';
                            } else {
                              _cpfError = null;
                            }

                            final data = _dataNascimentoController.text
                                .replaceAll(RegExp(r'[^0-9]'), '');
                            if (data.isEmpty) {
                              _dataNascimentoError = 'Data é obrigatória';
                            } else if (data.length < 8) {
                              _dataNascimentoError = 'Data incompleta';
                            } else {
                              _dataNascimentoError = null;
                            }
                          });

                          if (_cpfError != null ||
                              _dataNascimentoError != null) {
                            return;
                          }
                          final bloc = context.read<FormularioClientesBloc>();
                          final atualDto = bloc.state.clientDto;
                          bloc.add(
                            DocumentosEvent(
                              clientDto: atualDto.copyWith(
                                cpf: _cpfController.text,
                                cnpj: _cnpjController.text,
                                dataNascimento: _dataNascimentoController.text,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryDark,
                                AppColors.accentBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Próximo Passo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  LucideIcons.arrowRight,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 500.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }
}
