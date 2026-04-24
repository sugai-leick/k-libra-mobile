import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/app_colors.dart';
import 'package:flutter_app/core/widgets/layout/top_menu.dart';
import 'package:flutter_app/features/clients/presentation/widgets/clients_builder.dart';
import 'package:flutter_app/features/dashboard/presentation/page/dashboard_page.dart';

import 'package:flutter_app/features/sales/presentation/pages/sales_page.dart';
import 'package:flutter_app/features/payments/presentation/pages/payments_page.dart';
import 'package:flutter_app/features/inventory/presentation/widgets/inventory_builder.dart';
import 'package:flutter_app/features/shipping/presentation/pages/shipping_page.dart';
import 'package:flutter_app/features/fiscal/presentation/pages/fiscal_page.dart';
import 'package:flutter_app/features/support/presentation/pages/support_page.dart';
import 'package:flutter_app/features/conciliation/presentation/pages/conciliation_page.dart';
import 'package:flutter_app/features/automations/presentation/pages/automations_page.dart';
import 'package:flutter_app/features/alerts/presentation/pages/alerts_page.dart';
import 'package:flutter_app/features/approvals/presentation/pages/approvals_page.dart';
import 'package:flutter_app/features/financial/presentation/pages/strategic_financial_page.dart';
import 'package:flutter_app/features/reports/presentation/pages/reports_page.dart';
import 'package:flutter_app/features/goals/presentation/pages/goals_page.dart';
import 'package:flutter_app/features/insights/presentation/pages/insights_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const SalesPage(),
    const ClientsBuilder(),
    const InventoryBuilder(),
    const ShippingPage(),
    const PaymentsPage(),
    const ConciliationPage(),
    const AutomationsPage(),
    const AlertsPage(),
    const ApprovalsPage(),
    const StrategicFinancialPage(),
    const ReportsPage(),
    const GoalsPage(),
    const InsightsPage(),
    const FiscalPage(),
    const SupportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            TopMenu(
              currentIndex: _currentIndex,
              onPageSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
