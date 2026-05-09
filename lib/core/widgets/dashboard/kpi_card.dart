import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// A generic card widget used to display Key Performance Indicators (KPIs).
///
/// It features a glassmorphic design with a background glow effect,
/// displaying a [label], a primary [value], and an [icon] associated with the metric.
class KpiCard extends StatelessWidget {
  /// The descriptive name of the metric (e.g., "Total Revenue").
  final String label;

  /// The formatted value to be displayed (e.g., "$ 12,000").
  final String value;

  /// The icon representing the metric.
  final IconData icon;

  /// The primary color used for the icon and the background glow effect.
  final Color color;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Stack(
        children: [
          // Background glow
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                ],
              ),
              // Se o valor estiver carregando (for "..."), desenha os pontinhos animados!
              value == '...'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Text(
                            '.',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat()) // Fica repetindo infinito
                              // Cresce o ponto
                              .scaleXY(
                                begin: 1,
                                end: 1.5,
                                duration: 300.ms,
                                delay: (index * 150).ms, // Atraso de 150ms pra cada ponto
                                curve: Curves.easeInOut,
                              )
                              .then()
                              // Volta o ponto pro tamanho normal
                              .scaleXY(
                                begin: 1.5,
                                end: 1,
                                duration: 300.ms,
                                curve: Curves.easeInOut,
                              ),
                        );
                      }),
                    )
                  // Mas se chegou o número de verdade, plota o texto normal
                  : Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
