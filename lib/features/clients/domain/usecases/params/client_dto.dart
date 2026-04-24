class ClientDto {
  // --- Identificação Básica ---
  final String nomeCompleto;
  final String email;
  final String telefone;

  // --- Documentos e Data ---
  final String? cpf;
  final String? cnpj;
  final String? dataNascimento;

  // --- Profissional e Redes ---
  final String? ocupacao;
  final String? instagram;
  final String? origem;
  final String? observacao;

  // --- Roles / Vínculos ---
  final String status;
  final String partyStatus;
  final bool isCustomer;
  final bool isSupplier;

  // --- Endereço Residencial ---
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? complemento;

  const ClientDto({
    this.nomeCompleto = '',
    this.email = '',
    this.telefone = '',
    this.status = 'lead',
    this.partyStatus = 'active',
    this.isCustomer = false,
    this.isSupplier = false,
    this.cpf,
    this.cnpj,
    this.dataNascimento,
    this.ocupacao,
    this.instagram,
    this.origem = 'whatsapp',
    this.observacao,
    this.cep,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.estado,
    this.complemento,
  });

  ClientDto copyWith({
    String? nomeCompleto,
    String? email,
    String? telefone,
    String? cpf,
    String? cnpj,
    String? dataNascimento,
    String? ocupacao,
    String? instagram,
    String? origem,
    String? observacao,
    String? status,
    String? partyStatus,
    bool? isCustomer,
    bool? isSupplier,
    String? cep,
    String? logradouro,
    String? numero,
    String? bairro,
    String? cidade,
    String? estado,
    String? complemento,
  }) {
    return ClientDto(
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      cnpj: cnpj ?? this.cnpj,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      ocupacao: ocupacao ?? this.ocupacao,
      instagram: instagram ?? this.instagram,
      origem: origem ?? this.origem,
      observacao: observacao ?? this.observacao,
      status: status ?? this.status,
      partyStatus: partyStatus ?? this.partyStatus,
      isCustomer: isCustomer ?? this.isCustomer,
      isSupplier: isSupplier ?? this.isSupplier,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      complemento: complemento ?? this.complemento,
    );
  }

  factory ClientDto.fromEntity(dynamic customer) {
    // Usamos dynamic para evitar circular dependency ou importar a entidade se necessário
    // Mas aqui podemos importar sem problemas se estiver no mesmo módulo
    return ClientDto(
      nomeCompleto: customer.nomeCompleto,
      email: customer.email ?? '',
      telefone: customer.telefone ?? '',
      cpf: customer.cpf,
      cnpj: customer.cnpj,
      dataNascimento: customer.dataNascimento,
      ocupacao: customer.ocupacao,
      instagram: customer.instagram,
      origem: customer.origem ?? 'whatsapp',
      observacao: customer.observacao,
      status: customer.status,
      partyStatus: customer.partyStatus ?? 'active',
      isCustomer: customer.isCustomer ?? false,
      isSupplier: customer.isSupplier ?? false,
      cep: customer.enderecoResidencial?.cep,
      logradouro: customer.enderecoResidencial?.rua,
      numero: customer.enderecoResidencial?.numero,
      bairro: customer.enderecoResidencial?.bairro,
      cidade: customer.enderecoResidencial?.cidade,
      estado: customer.enderecoResidencial?.estado,
      complemento: customer.enderecoResidencial?.complemento,
    );
  }
}
