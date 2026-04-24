import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String rua;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;

  const AddressEntity({
    required this.rua,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  @override
  List<Object?> get props => [rua, numero, complemento, bairro, cidade, estado, cep];
}

class CustomerEntity extends Equatable {
  final String? id;
  final String nomeCompleto;
  final String? cpf;
  final String? cnpj;
  final String? email;
  final String? telefone;
  final String status;
  final String? dataNascimento;
  final String? instagram;
  final String? ocupacao;
  final String? observacao;
  final String? origem;
  final String? partyStatus;
  final bool? isCustomer;
  final bool? isSupplier;
  final AddressEntity? enderecoResidencial;

  const CustomerEntity({
    this.id,
    required this.nomeCompleto,
    this.cpf,
    this.cnpj,
    this.email,
    this.telefone,
    required this.status,
    this.dataNascimento,
    this.instagram,
    this.ocupacao,
    this.observacao,
    this.origem,
    this.partyStatus,
    this.isCustomer,
    this.isSupplier,
    this.enderecoResidencial,
  });

  @override
  List<Object?> get props => [
    id, nomeCompleto, cpf, cnpj, email, telefone, status, 
    dataNascimento, instagram, ocupacao, observacao, origem, 
    partyStatus, isCustomer, isSupplier,
    enderecoResidencial
  ];
}
