import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.rua,
    required super.numero,
    super.complemento,
    required super.bairro,
    required super.cidade,
    required super.estado,
    required super.cep,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      rua: json['rua'] as String? ?? 'S/N',
      numero: json['numero'] as String? ?? 'S/N',
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String? ?? '',
      cidade: json['cidade'] as String? ?? '',
      estado: json['uf'] as String? ?? json['estado'] as String? ?? '',
      cep: json['cep'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': _formatCep(cep),
      'CEP': _formatCep(cep),
    };
  }

  String _formatCep(String value) {
    if (value.isEmpty) return '00000-000';
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 8) {
      return '${digits.substring(0, 5)}-${digits.substring(5)}';
    }
    return value;
  }
}

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    super.id,
    required super.nomeCompleto,
    super.cpf,
    super.cnpj,
    super.email,
    super.telefone,
    required super.status,
    super.dataNascimento,
    super.instagram,
    super.ocupacao,
    super.observacao,
    super.origem,
    super.partyStatus,
    super.isCustomer,
    super.isSupplier,
    super.enderecoResidencial,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String?,
      nomeCompleto: json['nome_completo'] as String? ?? 'Nome não fornecido',
      cpf: json['cpf'] as String?,
      cnpj: json['cnpj'] as String?,
      email: json['email'] as String?,
      telefone: json['telefone'] as String?,
      status: json['status'] as String? ?? 'lead',
      dataNascimento: json['data_nascimento'] as String?,
      instagram: json['instagram'] as String?,
      ocupacao: json['ocupacao'] as String?,
      observacao: json['observacao'] as String?,
      origem: json['origem'] as String?,
      partyStatus: json['party_status'] as String?,
      isCustomer: json['is_customer'] as bool?,
      isSupplier: json['is_supplier'] as bool?,
      enderecoResidencial: json['endereco_residencial'] != null
          ? AddressModel.fromJson(json['endereco_residencial'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'cnpj': cnpj,
      'email': email,
      'telefone': telefone,
      'status': status,
      'data_nascimento': _formatDate(dataNascimento),
      'instagram': instagram,
      'ocupacao': ocupacao,
      'observacao': observacao,
      'origem': origem,
      'party_status': partyStatus == 'ativo' ? 'active' : (partyStatus ?? 'active'),
      'is_customer': isCustomer ?? true,
      'is_supplier': isSupplier ?? false,
      'endereco_residencial': (enderecoResidencial as AddressModel?)?.toJson(),
      'endereco_entrega': (enderecoResidencial as AddressModel?)?.toJson(),
    };
  }

  String? _formatDate(String? dt) {
    if (dt == null || dt.isEmpty) return null;
    // Converte 'DD/MM/YYYY' para 'YYYY-MM-DD'
    final parts = dt.split('/');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return dt;
  }
}
