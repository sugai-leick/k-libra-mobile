part of 'formulario_clientes_bloc.dart';

@immutable
sealed class FormularioClientesEvent {}

class DadosIdentificacaoEvent extends FormularioClientesEvent {
  final ClientDto clientDto;
  DadosIdentificacaoEvent({required this.clientDto});
}

class DocumentosEvent extends FormularioClientesEvent {
  final ClientDto clientDto;
  DocumentosEvent({required this.clientDto});
}

class EnderecoEvent extends FormularioClientesEvent {
  final ClientDto clientDto;
  EnderecoEvent({required this.clientDto});
}

class ProfissionalExtrasEvent extends FormularioClientesEvent {
  final ClientDto clientDto;
  ProfissionalExtrasEvent({required this.clientDto});
}

class SubmitFormularioEvent extends FormularioClientesEvent {}

class VoltarEtapaEvent extends FormularioClientesEvent {
  final ClientDto clientDto;
  VoltarEtapaEvent({required this.clientDto});
}

class EditarClienteEvent extends FormularioClientesEvent {
  final CustomerEntity customer;
  EditarClienteEvent({required this.customer});
}
