import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/presentation/widgets/custom_form_field.dart';

class ProfissionalExtrasStep extends StatefulWidget {
  const ProfissionalExtrasStep({super.key});

  @override
  State<ProfissionalExtrasStep> createState() => _ProfissionalExtrasStepState();
}

class _ProfissionalExtrasStepState extends State<ProfissionalExtrasStep> {
  late String _ocupacao;
  late TextEditingController _instagramController;
  late String _origem;
  late TextEditingController _observacaoController;

  @override
  void initState() {
    super.initState();
    final dto = context.read<FormularioClientesBloc>().state.clientDto;
    _ocupacao = dto.ocupacao ?? 'dentista';
    _instagramController = TextEditingController(text: dto.instagram ?? '');
    _origem = dto.origem ?? 'whatsapp';
    _observacaoController = TextEditingController(text: dto.observacao ?? '');
  }

  @override
  void dispose() {
    _instagramController.dispose();
    _observacaoController.dispose();
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
            'Profissional e Extras',
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 8),
          Text(
            'Detalhes profissionais e informações adicionais.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ).animate().fadeIn(delay: 100.ms).moveY(begin: -10, end: 0),
          const SizedBox(height: 32),

          _buildLabel('Ocupação'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _ocupacao,
                isExpanded: true,
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  const DropdownMenuItem(value: 'dentista', child: Text('Dentista')),
                  const DropdownMenuItem(value: 'protesico', child: Text('Protético')),
                  if (_ocupacao != 'dentista' && _ocupacao != 'protesico')
                    DropdownMenuItem(value: _ocupacao, child: Text(_ocupacao)),
                ],
                onChanged: (val) => setState(() => _ocupacao = val!),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 24),

          CustomFormField(
            controller: _instagramController,
            hint: 'Instagram (ex: @user)',
            icon: LucideIcons.mail,
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 24),

          _buildLabel('Origem do Lead'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _origem,
                isExpanded: true,
                dropdownColor: Theme.of(context).cardColor,
                items: [
                  const DropdownMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                  const DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
                  const DropdownMenuItem(value: 'indicacao', child: Text('Indicação')),
                  const DropdownMenuItem(value: 'outros', child: Text('Outros')),
                  if (_origem != 'whatsapp' && _origem != 'instagram' && _origem != 'indicacao' && _origem != 'outros')
                    DropdownMenuItem(value: _origem, child: Text('Importado: $_origem')),
                ],
                onChanged: (val) => setState(() => _origem = val!),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05, end: 0),
          const SizedBox(height: 24),

          _buildLabel('Observações'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _observacaoController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Notas adicionais...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.05, end: 0),
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
                            ocupacao: _ocupacao,
                            instagram: _instagramController.text,
                            origem: _origem,
                            observacao: _observacaoController.text,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.accentBlue.withValues(alpha: 0.5), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Voltar', style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold, fontSize: 16)),
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
                      final bloc = context.read<FormularioClientesBloc>();
                      final atualDto = bloc.state.clientDto;
                      bloc.add(
                        ProfissionalExtrasEvent(
                          clientDto: atualDto.copyWith(
                            ocupacao: _ocupacao,
                            instagram: _instagramController.text,
                            origem: _origem,
                            observacao: _observacaoController.text,
                          ),
                        ),
                      );
                      
                      // Agora manda salvar de fato:
                      bloc.add(SubmitFormularioEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.accentBlue]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: BlocBuilder<FormularioClientesBloc, FormularioClientGlobalState>(
                          builder: (context, state) {
                            final isEditing = state.editingClientId != null;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isEditing ? 'Salvar Alterações' : 'Finalizar Cadastro',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isEditing ? LucideIcons.save : LucideIcons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.6)));
  }
}
