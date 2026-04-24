import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/services/viacep/viacep_service.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/presentation/widgets/custom_form_field.dart';

class EnderecoStep extends StatefulWidget {
  const EnderecoStep({super.key});

  @override
  State<EnderecoStep> createState() => _EnderecoStepState();
}

class _EnderecoStepState extends State<EnderecoStep> {
  late TextEditingController _cepController;
  late TextEditingController _logradouroController;
  late TextEditingController _numeroController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  late TextEditingController _complementoController;

  final ViacepService _viacepService = ViacepService();
  String _lastFetchCep = '';

  String? _cepError;
  String? _numeroError;

  @override
  void initState() {
    super.initState();
    final dto = context.read<FormularioClientesBloc>().state.clientDto;
    _cepController = TextEditingController(text: dto.cep ?? '');
    _logradouroController = TextEditingController(text: dto.logradouro ?? '');
    _numeroController = TextEditingController(text: dto.numero ?? '');
    _bairroController = TextEditingController(text: dto.bairro ?? '');
    _cidadeController = TextEditingController(text: dto.cidade ?? '');
    _estadoController = TextEditingController(text: dto.estado ?? '');
    _complementoController = TextEditingController(text: dto.complemento ?? '');

    _cepController.addListener(_onCepChanged);
  }

  void _onCepChanged() async {
    final text = _cepController.text;
    final cleanCep = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCep.length == 8 && cleanCep != _lastFetchCep) {
      _lastFetchCep = cleanCep;

      final isDark = Theme.of(context).brightness == Brightness.dark;
      final bgColor = isDark ? AppColors.cardDark : Colors.white;
      final fgColor = isDark ? Colors.white : Colors.black87;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: bgColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentBlue,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Buscando endereço...',
                style: GoogleFonts.inter(
                  color: fgColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );

      final data = await _viacepService.fetchCep(cleanCep);
      if (!mounted) {
        return;
      }

      if (data != null) {
        setState(() {
          if (data['logradouro'] != null && data['logradouro'] != '') {
            _logradouroController.text = data['logradouro'];
          }
          if (data['bairro'] != null && data['bairro'] != '') {
            _bairroController.text = data['bairro'];
          }
          if (data['localidade'] != null && data['localidade'] != '') {
            _cidadeController.text = data['localidade'];
          }
          if (data['uf'] != null && data['uf'] != '') {
            _estadoController.text = data['uf'];
          }
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('CEP não encontrado ou erro de rede.'),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cepController.removeListener(_onCepChanged);
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Endereço',
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 8),
          Text(
            'Informe o local de atuação ou residência.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ).animate().fadeIn(delay: 100.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomFormField(
                  controller: _cepController,
                  hint: 'CEP *',
                  icon: LucideIcons.mapPin,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  errorText: _cepError,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: CustomFormField(
                  controller: _estadoController,
                  hint: 'UF',
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _cidadeController,
            hint: 'Cidade',
            icon: LucideIcons.building,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomFormField(
                  controller: _logradouroController,
                  hint: 'Logradouro (Rua, Av...)',
                  icon: LucideIcons.mapPin,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: CustomFormField(
                  controller: _numeroController,
                  hint: 'Nº *',
                  keyboardType: TextInputType.number,
                  errorText: _numeroError,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _bairroController,
            hint: 'Bairro',
            icon: LucideIcons.map,
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 16),

          CustomFormField(
            controller: _complementoController,
            hint: 'Complemento (opcional)',
            icon: Icons.add_business_outlined,
          ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.05, end: 0),
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
                                cep: _cepController.text,
                                logradouro: _logradouroController.text,
                                numero: _numeroController.text,
                                bairro: _bairroController.text,
                                cidade: _cidadeController.text,
                                estado: _estadoController.text,
                                complemento: _complementoController.text,
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
                            final cep = _cepController.text.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (cep.isEmpty) {
                              _cepError = 'CEP é obrigatório';
                            } else if (cep.length < 8) {
                              _cepError = 'CEP incompleto';
                            } else {
                              _cepError = null;
                            }

                            if (_numeroController.text.isEmpty) {
                              _numeroError = 'Nº é obrigatório';
                            } else {
                              _numeroError = null;
                            }
                          });

                          if (_cepError != null || _numeroError != null) {
                            return;
                          }

                          final bloc = context.read<FormularioClientesBloc>();
                          final atualDto = bloc.state.clientDto;
                          bloc.add(
                            EnderecoEvent(
                              clientDto: atualDto.copyWith(
                                cep: _cepController.text,
                                logradouro: _logradouroController.text,
                                numero: _numeroController.text,
                                bairro: _bairroController.text,
                                cidade: _cidadeController.text,
                                estado: _estadoController.text,
                                complemento: _complementoController.text,
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
              .fadeIn(delay: 700.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }
}
