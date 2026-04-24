import 'package:dio/dio.dart';
import 'package:flutter_app/features/inventory/data/models/consumable_model.dart';
import 'package:flutter_app/features/inventory/data/models/hardware_model.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';

abstract class InventoryRemoteDatasource {
  Future<Map<String, dynamic>> fetchInventory();
  Future<void> registerHardware(AddHardwareDto dto);
  Future<void> registerTransaction(InventoryTransactionDto dto);
}

class InventoryRemoteDatasourceImpl implements InventoryRemoteDatasource {
  final Dio dio;

  InventoryRemoteDatasourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> fetchInventory() async {
    try {
      final response = await dio.get('/inventory');
      
      final Map<String, dynamic> results = {
        'hardware': <HardwareModel>[],
        'consumables': <ConsumableModel>[],
      };

      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          // Case 1: The response is structured like { "hardwares": [], "consumables": [] }
          final map = response.data as Map<String, dynamic>;
          
          final hwList = map['hardware'] ?? map['hardwares'] ?? map['equipments'] ?? [];
          final csList = map['items'] ?? map['consumables'] ?? map['products'] ?? [];

          if (hwList is List) {
            results['hardware'] = hwList.map((e) => HardwareModel.fromJson(e)).toList();
          }
          if (csList is List) {
            results['consumables'] = csList.map((e) => ConsumableModel.fromJson(e)).toList();
          }
        } else if (response.data is List) {
          // Case 2: The response is a single fat flat list
          final list = response.data as List;
          final List<HardwareModel> hws = [];
          final List<ConsumableModel> css = [];

          for (var item in list) {
            if (item is Map<String, dynamic>) {
              bool isHardware = item['type'] == 'hardware' || 
                                item['is_hardware'] == true || 
                                item.containsKey('serial_number') || 
                                item.containsKey('serialNumber');
              if (isHardware) {
                hws.add(HardwareModel.fromJson(item));
              } else {
                css.add(ConsumableModel.fromJson(item));
              }
            }
          }
          results['hardware'] = hws;
          results['consumables'] = css;
        }
      }

      return results;
    } on DioException catch (e) {
      throw Exception('Falha ao obter estoque da API: ${e.response?.statusMessage ?? e.message}');
    } catch (e) {
      throw Exception('Erro de serialização do estoque: $e');
    }
  }

  @override
  Future<void> registerHardware(AddHardwareDto dto) async {
    try {
      await dio.post('/inventory/hardware', data: dto.toJson());
    } on DioException catch (e) {
      throw Exception('Falha ao adicionar hardware: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Erro ao registrar hardware: $e');
    }
  }

  @override
  Future<void> registerTransaction(InventoryTransactionDto dto) async {
    try {
      await dio.post('/inventory/transaction', data: dto.toJson());
    } on DioException catch (e) {
      throw Exception('Falha ao lançar transação de estoque: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Erro ao transacionar estoque: $e');
    }
  }
}
