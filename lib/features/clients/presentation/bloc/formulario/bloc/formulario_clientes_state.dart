part of 'formulario_clientes_bloc.dart';

enum FormSubmissionStatus {
  initial,
  loading,
  success,
  failure,
}

enum FormSection {
  dadosIdentificacao,
  documentos,
  endereco,
  profissionalExtras,
}

final class FormularioClientGlobalState {
  final FormSubmissionStatus submissionStatus; // Controla se tá carregando pro servidor
  final FormSection sessaoAtual;               // Controla em qual aba o celular está
  final ClientDto clientDto;
  final int stepAtual;                         // Número pra barra de progresso (ex: 1/4)
  final String? editingClientId;
  final String errorMsg;
  final bool isLoading;

   FormularioClientGlobalState({
    this.submissionStatus = FormSubmissionStatus.initial,
    this.sessaoAtual = FormSection.dadosIdentificacao,
    this.clientDto = const ClientDto(),
    this.stepAtual = 1,
    this.editingClientId,
    this.errorMsg = '',
    this.isLoading = false,
  });

  FormularioClientGlobalState copyWith({
    FormSubmissionStatus? submissionStatus,
    FormSection? sessaoAtual,
    ClientDto? clientDto,
    int? stepAtual,
    String? editingClientId,
    String? errorMsg,
    bool? isLoading,
  }) {
    return FormularioClientGlobalState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      sessaoAtual: sessaoAtual ?? this.sessaoAtual,
      clientDto: clientDto ?? this.clientDto,
      stepAtual: stepAtual ?? this.stepAtual,
      editingClientId: editingClientId ?? this.editingClientId,
      errorMsg: errorMsg ?? this.errorMsg,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
