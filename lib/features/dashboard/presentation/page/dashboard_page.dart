import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/features/dashboard/presentation/widgets/dashboard_funnel_section.dart';
import 'package:flutter_app/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:flutter_app/features/dashboard/presentation/widgets/dashboard_insights_section.dart';
import 'package:flutter_app/features/dashboard/presentation/widgets/dashboard_kpi_grid.dart';

/// [DashboardPage] is the primary overview screen for the K-Libra system.
///
/// It provides a high-level summary of the Institute's performance, including:
/// - Key Performance Indicators (KPIs) via [DashboardKpiGrid]
/// - Business Insights (Top Buyer, Ticket Mean, etc.) via [DashboardInsightsSection]
/// - Conversion Funnel metrics via [DashboardFunnelSection]
///
/// The page is built using a [CustomScrollView] with [Sliver] widgets to ensure
/// smooth scrolling and modularity.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a CustomScrollView to allow each section to be a Sliver,
    // which is better for performance and flexible layouts.
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            DashboardHeader(),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            DashboardKpiGrid(),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            DashboardInsightsSection(),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            DashboardFunnelSection(),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
