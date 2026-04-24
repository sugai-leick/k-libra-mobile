import 'package:flutter/material.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'client_card_content.dart';

class ClientCardItem extends StatefulWidget {
  final CustomerEntity client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClientCardItem({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ClientCardItem> createState() => _ClientCardItemState();
}

class _ClientCardItemState extends State<ClientCardItem> {
  double _dragExtent = 0;
  final double _actionsWidth = 140;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta!;
      if (_dragExtent > 0) _dragExtent = 0;
      if (_dragExtent < -_actionsWidth - 30) _dragExtent = -_actionsWidth - 30;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragExtent < -_actionsWidth / 2) {
      setState(() => _dragExtent = -_actionsWidth);
    } else {
      setState(() => _dragExtent = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Stack(
        children: [
          // Background (Actions)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1A1A1A),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _dragExtent = 0);
                        widget.onEdit();
                      },
                      child: Container(
                        width: 70,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(4),
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _dragExtent = 0);
                        widget.onDelete();
                      },
                      child: Container(
                        width: 70,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(16),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content Layer (Sliding)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Transform.translate(
              offset: Offset(_dragExtent, 0),
              child: ClientCardContent(client: widget.client),
            ),
          ),
        ],
      ),
    );
  }
}
