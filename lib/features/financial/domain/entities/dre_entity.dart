import 'package:equatable/equatable.dart';

/// [DreEntity] represents the Statement of Income (DRE) data.
class DreEntity extends Equatable {
  final double revenue;
  final double deductions;
  final double netRevenue;
  final double cogs;
  final double grossProfit;
  final double opex;
  final double netIncome;
  final DreMetadataEntity? metadata;

  const DreEntity({
    required this.revenue,
    required this.deductions,
    required this.netRevenue,
    required this.cogs,
    required this.grossProfit,
    required this.opex,
    required this.netIncome,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        revenue,
        deductions,
        netRevenue,
        cogs,
        grossProfit,
        opex,
        netIncome,
        metadata,
      ];
}

/// [DreMetadataEntity] provides audit and health information about the DRE data.
class DreMetadataEntity extends Equatable {
  final int totalCount;
  final int dbTotalCount;
  final int inconsistentCount;
  final double dataQualityScore;
  final String qualityLevel;
  final String riskImpact;
  final DataHorizonEntity? dataHorizon;

  const DreMetadataEntity({
    required this.totalCount,
    required this.dbTotalCount,
    required this.inconsistentCount,
    required this.dataQualityScore,
    required this.qualityLevel,
    required this.riskImpact,
    this.dataHorizon,
  });

  @override
  List<Object?> get props => [
        totalCount,
        dbTotalCount,
        inconsistentCount,
        dataQualityScore,
        qualityLevel,
        riskImpact,
        dataHorizon,
      ];
}

/// [DataHorizonEntity] indicates the time range where data exists in the system.
class DataHorizonEntity extends Equatable {
  final String min;
  final String max;

  const DataHorizonEntity({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];
}
