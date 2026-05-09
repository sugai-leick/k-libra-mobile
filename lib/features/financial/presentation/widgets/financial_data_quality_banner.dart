import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

import 'financial_audit_banner.dart';
import 'financial_critical_banner.dart';
import 'financial_guidance_banner.dart';
import 'financial_onboarding_banner.dart';

/// [FinancialDataQualityBanner] is a modular orchestrator component that displays different
/// alerts based on the health and quality of financial data.
/// It delegates the UI rendering to specific sub-banners depending on the current state.
class FinancialDataQualityBanner extends StatelessWidget {
  final DreMetadataEntity? metadata;
  final bool isLoading;
  final String from;
  final Function(String from, String to) onJump;

  const FinancialDataQualityBanner({
    super.key,
    this.metadata,
    this.isLoading = false,
    required this.from,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    final dbCount = metadata?.dbTotalCount ?? 0;

    // 1. ONBOARDING STATE: No data at all in the database
    if (metadata == null || dbCount == 0) {
      return const FinancialOnboardingBanner();
    }

    // 2. GUIDANCE STATE: Data exists in DB but not in current period
    if (metadata!.totalCount == 0 && dbCount > 0) {
      return FinancialGuidanceBanner(
        from: from,
        metadata: metadata!,
        onJump: onJump,
      );
    }

    // 3. CRITICAL STATE: Critical inconsistencies detected
    if (metadata!.inconsistentCount > 0) {
      return FinancialCriticalBanner(metadata: metadata!);
    }

    // 4. AUDIT STATE: Data is healthy or has moderate quality
    return FinancialAuditBanner(metadata: metadata!);
  }

  Widget _buildLoadingState() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.05));
  }
}
