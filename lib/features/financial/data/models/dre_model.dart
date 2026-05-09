import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

class DreModel extends DreEntity {
  const DreModel({
    required super.revenue,
    required super.deductions,
    required super.netRevenue,
    required super.cogs,
    required super.grossProfit,
    required super.opex,
    required super.netIncome,
    super.metadata,
  });

  factory DreModel.fromJson(Map<String, dynamic> json) {
    return DreModel(
      revenue: (json['revenue'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      netRevenue: (json['netRevenue'] as num).toDouble(),
      cogs: (json['cogs'] as num).toDouble(),
      grossProfit: (json['grossProfit'] as num).toDouble(),
      opex: (json['opex'] as num).toDouble(),
      netIncome: (json['netIncome'] as num).toDouble(),
      metadata: json['metadata'] != null
          ? DreMetadataModel.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DreMetadataModel extends DreMetadataEntity {
  const DreMetadataModel({
    required super.totalCount,
    required super.dbTotalCount,
    required super.inconsistentCount,
    required super.dataQualityScore,
    required super.qualityLevel,
    required super.riskImpact,
    super.dataHorizon,
  });

  factory DreMetadataModel.fromJson(Map<String, dynamic> json) {
    return DreMetadataModel(
      totalCount: json['totalCount'] as int,
      dbTotalCount: json['dbTotalCount'] as int? ?? 0,
      inconsistentCount: json['inconsistentCount'] as int,
      dataQualityScore: (json['dataQualityScore'] as num).toDouble(),
      qualityLevel: json['qualityLevel'] as String,
      riskImpact: json['riskImpact'] as String,
      dataHorizon: json['dataHorizon'] != null
          ? DataHorizonModel.fromJson(
              json['dataHorizon'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DataHorizonModel extends DataHorizonEntity {
  const DataHorizonModel({
    required super.min,
    required super.max,
  });

  factory DataHorizonModel.fromJson(Map<String, dynamic> json) {
    return DataHorizonModel(
      min: json['min'] as String,
      max: json['max'] as String,
    );
  }
}
