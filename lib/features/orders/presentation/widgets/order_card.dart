// lib/presentation/widgets/order_card.dart
import 'package:flutter/material.dart';
import '../../../../core/widgets/place.dart';
import '../../../map/presentation/screens/map_screen.dart';
import '../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ Use the passed onTap callback
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 408,
          height: 320,
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                bottom: 90,
                child: Container(
                  color: Colors.grey[200],
                  child: order.productImage != null
                      ? Image.network(
                    order.productImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 60)),
                  )
                      : const Center(child: Icon(Icons.image, size: 100)),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          if (order.latitude != null && order.longitude != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapScreen(
                                  location: PlaceLocation(
                                    latitude: order.latitude!,
                                    longitude: order.longitude!,
                                    address: order.customerAddress,
                                  ),
                                  isSelecting: false,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Location not available for this order.')),
                            );
                          }
                        },
                        child: Text(
                          order.customerAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 45,
                child: _buildEnhancedStatusChip(order.status),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Text(
                  order.estimatedTime,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProgressDot(active: true),
                    const SizedBox(width: 6),
                    _buildProgressDot(active: false),
                    const SizedBox(width: 6),
                    _buildProgressDot(active: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatusChip(String status) {
    final (Color bgColor, Color textColor, String label) = switch (status.toLowerCase()) {
      'unfinished' => (const Color(0xFFF0F7D4), const Color(0xFF5E7C16), 'In Progress'),
      'failed' => (const Color(0xFFFDE8E8), const Color(0xFFD32F2F), 'Failed'),
      'pass' => (const Color(0xFFE8F5E9), const Color(0xFF2E7D32), 'Completed'),
      _ => (Colors.grey[200]!, Colors.grey[800]!, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), color: textColor, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    return switch (status.toLowerCase()) {
      'unfinished' => Icons.access_time,
      'failed' => Icons.error_outline,
      'pass' => Icons.check_circle_outline,
      _ => Icons.info_outline,
    };
  }

  Widget _buildProgressDot({required bool active}) {
    return Container(
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}