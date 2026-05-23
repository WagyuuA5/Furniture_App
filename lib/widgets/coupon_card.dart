import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coupon_model.dart';
import '../utils/constants.dart';

class CouponCard extends StatefulWidget {
  final CouponModel coupon;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onCopied;

  const CouponCard({
    super.key,
    required this.coupon,
    this.isSelected = false,
    this.onTap,
    this.onCopied,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _copyController;
  late Animation<double> _scaleAnim;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _copyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(parent: _copyController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _copyController.dispose();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.coupon.code));
    setState(() => _copied = true);
    _copyController.forward().then((_) => _copyController.reverse());
    widget.onCopied?.call();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Color get _typeColor {
    switch (widget.coupon.type) {
      case CouponType.shipping:
        return const Color(0xFF1E88E5);
      case CouponType.cashback:
        return const Color(0xFF9C27B0);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor;
    final isLocked = widget.coupon.isLocked;

    return GestureDetector(
      onTap: isLocked ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isSelected ? color : Colors.grey.shade200,
            width: widget.isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Opacity(
            opacity: isLocked ? 0.75 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left colored stripe + emoji
                  Container(
                    width: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color, color.withOpacity(0.7)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.coupon.emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                        const SizedBox(height: 4),
                        _buildBadge(),
                      ],
                    ),
                  ),
                  // Dashed divider
                  _DashedDivider(color: Colors.grey.shade300),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.coupon.code,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              if (widget.isSelected)
                                Icon(Icons.check_circle_rounded,
                                    color: color, size: 20),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.coupon.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.coupon.benefitLabel,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ScaleTransition(
                                scale: _scaleAnim,
                                child: GestureDetector(
                                  onTap: _handleCopy,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: _copied
                                          ? Colors.green
                                          : color,
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _copied ? '✓ Disalin!' : 'COPY CODE',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLocked && widget.coupon.lockMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(Icons.lock_outline,
                                      size: 11,
                                      color: Colors.orange.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.coupon.lockMessage!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    if (widget.coupon.badge == CouponBadge.none) return const SizedBox();
    String label;
    Color badgeColor;
    switch (widget.coupon.badge) {
      case CouponBadge.popular:
        label = 'Popular';
        badgeColor = Colors.amber.shade700;
        break;
      case CouponBadge.limited:
        label = 'Limited';
        badgeColor = Colors.red.shade600;
        break;
      case CouponBadge.hot:
        label = 'HOT';
        badgeColor = Colors.deepOrange;
        break;
      default:
        return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);

    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}