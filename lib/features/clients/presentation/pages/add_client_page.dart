import 'package:flutter/material.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/features/clients/presentation/bloc/formulario/bloc/formulario_clientes_bloc.dart';
import 'package:flutter_app/features/clients/presentation/widgets/form_steps/dados_identificacao_step.dart';
import 'package:flutter_app/features/clients/presentation/widgets/form_steps/documentos_step.dart';
import 'package:flutter_app/features/clients/presentation/widgets/form_steps/endereco_step.dart';
import 'package:flutter_app/features/clients/presentation/widgets/form_steps/profissional_extras_step.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';

class AddClientPage extends StatefulWidget {
  final CustomerEntity? client;
  const AddClientPage({super.key, this.client});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client != null ? 'Editar Cliente' : 'Novo Cadastro',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider<FormularioClientesBloc>(
          create: (context) => sl<FormularioClientesBloc>(param1: widget.client),
          child: BlocConsumer<FormularioClientesBloc, FormularioClientGlobalState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentStep(state.sessaoAtual),
              );
            },
            listener: (context, state) {
              if (state.submissionStatus == FormSubmissionStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(
                    widget.client != null 
                        ? 'Cliente atualizado com sucesso!' 
                        : 'Cliente cadastrado com sucesso!'
                  )),
                );
                Navigator.pop(context); // Volta para a listagem
              }
              
              if (state.submissionStatus == FormSubmissionStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro: ${state.errorMsg}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(FormSection section) {
    switch (section) {
      case FormSection.dadosIdentificacao:
        return const DadosIdentificacaoStep(key: ValueKey('identificacao'));
      case FormSection.documentos:
        return const DocumentosStep(key: ValueKey('documentos'));
      case FormSection.endereco:
        return const EnderecoStep(key: ValueKey('endereco'));
      case FormSection.profissionalExtras:
        return const ProfissionalExtrasStep(key: ValueKey('profissional'));
    }
  }
}
