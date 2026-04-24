part of 'sales_form_bloc.dart';

class SalesFormState extends Equatable {
  final List<CustomerEntity> students;
  final bool isLoadingStudents;
  final String? selectedCustomerId;
  
  final String saleType; // 'course', 'hardware', 'consumable'
  final String? selectedItemId; // ID do curso ou produto selecionado
  final String? selectedItemName; // Nome para exibição
  
  final int? courseSk;
  final String? courseId;
  final String planType;
  
  final int quantidade;
  final double valor;
  final double desconto;
  final double frete;
  
  final ShippingAddressEntity? shippingAddress;
  final bool useDifferentAddress;
  
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const SalesFormState({
    this.students = const [],
    this.isLoadingStudents = false,
    this.selectedCustomerId,
    this.saleType = 'course',
    this.selectedItemId,
    this.selectedItemName,
    this.courseSk,
    this.courseId,
    this.planType = 'base',
    this.quantidade = 1,
    this.valor = 0.0,
    this.desconto = 0.0,
    this.frete = 0.0,
    this.shippingAddress,
    this.useDifferentAddress = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  SalesFormState copyWith({
    List<CustomerEntity>? students,
    bool? isLoadingStudents,
    String? selectedCustomerId,
    String? saleType,
    String? selectedItemId,
    String? selectedItemName,
    int? courseSk,
    String? courseId,
    String? planType,
    int? quantidade,
    double? valor,
    double? desconto,
    double? frete,
    ShippingAddressEntity? shippingAddress,
    bool? useDifferentAddress,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return SalesFormState(
      students: students ?? this.students,
      isLoadingStudents: isLoadingStudents ?? this.isLoadingStudents,
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
      saleType: saleType ?? this.saleType,
      selectedItemId: selectedItemId ?? this.selectedItemId,
      selectedItemName: selectedItemName ?? this.selectedItemName,
      courseSk: courseSk ?? this.courseSk,
      courseId: courseId ?? this.courseId,
      planType: planType ?? this.planType,
      quantidade: quantidade ?? this.quantidade,
      valor: valor ?? this.valor,
      desconto: desconto ?? this.desconto,
      frete: frete ?? this.frete,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      useDifferentAddress: useDifferentAddress ?? this.useDifferentAddress,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        students,
        isLoadingStudents,
        selectedCustomerId,
        saleType,
        selectedItemId,
        planType,
        valor,
        quantidade,
        shippingAddress,
        useDifferentAddress,
        isSubmitting,
        isSuccess,
        error,
      ];
}
