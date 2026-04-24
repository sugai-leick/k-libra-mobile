import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/usecases/customers_usecases.dart';
import 'package:flutter_app/features/clients/domain/usecases/params/client_dto.dart';
import 'package:flutter/foundation.dart';

part 'formulario_clientes_event.dart';
part 'formulario_clientes_state.dart';

class FormularioClientesBloc
    extends Bloc<FormularioClientesEvent, FormularioClientGlobalState> {
  final CreateCustomerUseCase createCustomerUseCase;
  final UpdateCustomerUseCase updateCustomerUseCase;

  FormularioClientesBloc({
    required this.createCustomerUseCase,
    required this.updateCustomerUseCase,
  }) : super(FormularioClientGlobalState()) {
    on<DadosIdentificacaoEvent>(_dadosIdentificacao);
    on<DocumentosEvent>(_documentos);
    on<EnderecoEvent>(_endereco);
    on<ProfissionalExtrasEvent>(_profissionalExtras);
    on<SubmitFormularioEvent>(_submit);
    on<VoltarEtapaEvent>(_voltar);
    on<EditarClienteEvent>(_onEditarCliente);
  }

  _voltar(VoltarEtapaEvent event, Emitter<FormularioClientGlobalState> emit) {
    FormSection prevSection;
    int prevStep;
    switch (state.sessaoAtual) {
      case FormSection.profissionalExtras:
        prevSection = FormSection.endereco;
        prevStep = 3;
        break;
      case FormSection.endereco:
        prevSection = FormSection.documentos;
        prevStep = 2;
        break;
      case FormSection.documentos:
      default:
        prevSection = FormSection.dadosIdentificacao;
        prevStep = 1;
        break;
    }
    emit(state.copyWith(
      clientDto: event.clientDto,
      sessaoAtual: prevSection,
      stepAtual: prevStep,
    ));
  }

  _dadosIdentificacao(
    DadosIdentificacaoEvent event,
    Emitter<FormularioClientGlobalState> emit,
  ) {
    emit(state.copyWith(
      clientDto: event.clientDto, 
      sessaoAtual: FormSection.documentos,
      stepAtual: 2,
    ));
  }

  _documentos(
    DocumentosEvent event,
    Emitter<FormularioClientGlobalState> emit,
  ) {
    emit(state.copyWith(
      clientDto: event.clientDto,
      sessaoAtual: FormSection.endereco,
      stepAtual: 3,
    ));
  }

  _endereco(EnderecoEvent event, Emitter<FormularioClientGlobalState> emit) {
    emit(state.copyWith(
      clientDto: event.clientDto,
      sessaoAtual: FormSection.profissionalExtras,
      stepAtual: 4,
    ));
  }

  _profissionalExtras(
    ProfissionalExtrasEvent event,
    Emitter<FormularioClientGlobalState> emit,
  ) {
    emit(state.copyWith(clientDto: event.clientDto));
  }

  void _onEditarCliente(
    EditarClienteEvent event,
    Emitter<FormularioClientGlobalState> emit,
  ) {
    final c = event.customer;
    final dto = ClientDto(
      nomeCompleto: c.nomeCompleto,
      email: c.email ?? '',
      telefone: c.telefone ?? '',
      cpf: c.cpf,
      cnpj: c.cnpj,
      dataNascimento: c.dataNascimento,
      ocupacao: c.ocupacao,
      instagram: c.instagram,
      origem: c.origem ?? 'whatsapp',
      observacao: c.observacao,
      status: c.status,
      partyStatus: c.partyStatus ?? 'active',
      isCustomer: c.isCustomer ?? false,
      isSupplier: c.isSupplier ?? false,
      cep: c.enderecoResidencial?.cep,
      logradouro: c.enderecoResidencial?.rua,
      numero: c.enderecoResidencial?.numero,
      bairro: c.enderecoResidencial?.bairro,
      cidade: c.enderecoResidencial?.cidade,
      estado: c.enderecoResidencial?.estado,
      complemento: c.enderecoResidencial?.complemento,
    );

    emit(state.copyWith(
      clientDto: dto,
      editingClientId: c.id,
      sessaoAtual: FormSection.dadosIdentificacao,
      stepAtual: 1,
    ));
  }

  Future<void> _submit(
    SubmitFormularioEvent event,
    Emitter<FormularioClientGlobalState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: FormSubmissionStatus.loading));
    
    try {
      final dto = state.clientDto;
      
      // Mapeamento DTO -> Entity (Conforme Swagger da API)
      final customer = CustomerEntity(
        id: state.editingClientId, // ID para UPDATE se existir
        nomeCompleto: dto.nomeCompleto,
        email: dto.email,
        telefone: dto.telefone,
        cpf: dto.cpf,
        cnpj: dto.cnpj,
        dataNascimento: dto.dataNascimento,
        instagram: dto.instagram,
        ocupacao: dto.ocupacao,
        observacao: dto.observacao,
        origem: dto.origem,
        partyStatus: dto.partyStatus,
        isCustomer: dto.isCustomer,
        isSupplier: dto.isSupplier,
        status: dto.status,
        enderecoResidencial: AddressEntity(
          rua: dto.logradouro ?? '',
          numero: dto.numero ?? '',
          bairro: dto.bairro ?? '',
          cidade: dto.cidade ?? '',
          estado: dto.estado ?? '',
          cep: dto.cep ?? '',
          complemento: dto.complemento,
        ),
      );

      final result = state.editingClientId != null 
          ? await updateCustomerUseCase(customer)
          : await createCustomerUseCase(customer);
      
      result.fold(
        (failure) => emit(state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMsg: failure.msg,
        )),
        (_) => emit(state.copyWith(submissionStatus: FormSubmissionStatus.success)),
      );
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: FormSubmissionStatus.failure,
        errorMsg: e.toString(),
      ));
    }
  }
}
