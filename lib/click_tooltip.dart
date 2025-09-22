import 'package:flutter/material.dart';

class ClickTooltip extends StatefulWidget {
  final Widget tipContent;
  final Widget child;
  final double tooltipHeight;
  final Color shapeColor;
  final Color shadowColor;

  const ClickTooltip({
    super.key,
    required this.child,
    required this.tipContent,
    this.tooltipHeight = 60,
    this.shapeColor = Colors.white,
    this.shadowColor = Colors.black12
  });

  @override
  State<ClickTooltip> createState() => _ClickTooltipState();
}

class _ClickTooltipState extends State<ClickTooltip> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _widgetKey = GlobalKey();
  double toolTipWidth = 237;

  void _showTooltip() {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;

    final screenSize = MediaQuery.of(context).size;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final widgetSize = renderBox.size;

    const double triangleHeight = 8.0;
    final double tooltipWidth = toolTipWidth;
    final double tooltipHeightEstimate = widget.tooltipHeight + triangleHeight;

    double tooltipLeft =
        offset.dx + (widgetSize.width / 2) - (tooltipWidth / 2);
    double tooltipTop = offset.dy - tooltipHeightEstimate - triangleHeight;

    const double screenPadding = 8.0;

    if (tooltipLeft < screenPadding) {
      tooltipLeft = screenPadding;
    } else if (tooltipLeft + tooltipWidth > screenSize.width - screenPadding) {
      tooltipLeft = screenSize.width - tooltipWidth - screenPadding;
    }

    if (tooltipTop < screenPadding) {
      tooltipTop = screenPadding;
    }

    // ✅ Compute arrowOffset relative to widget.child
    double desiredArrowCenterXInTooltip =
        (offset.dx + widgetSize.width / 2) - tooltipLeft;
    double arrowOffset = desiredArrowCenterXInTooltip - (tooltipWidth / 2);

    const double arrowMaxEdgeOffset = 12.0;
    arrowOffset = arrowOffset.clamp(
      -(tooltipWidth / 2) +
          _TooltipShapeBorder().arrowWidth / 2 +
          arrowMaxEdgeOffset,
      (tooltipWidth / 2) -
          _TooltipShapeBorder().arrowWidth / 2 -
          arrowMaxEdgeOffset,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: tooltipLeft,
        top: tooltipTop,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: tooltipWidth,
            padding: const EdgeInsets.only(bottom: triangleHeight),
            decoration: ShapeDecoration(
              color: widget.shapeColor,
              shape: _TooltipShapeBorder(
                arrowOffset: arrowOffset, // ✅ pass computed arrow offset
              ),
              shadows: [
                BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: widget.tipContent,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), _hideTooltip);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _widgetKey,
      onTap: _showTooltip,
      child: widget.child,
    );
  }
}

class _TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth = 16.0;
  final double arrowHeight = 8.0;
  final double arrowOffset;
  final Radius radius = const Radius.circular(8.0);

  const _TooltipShapeBorder({
    this.arrowOffset = 0.0
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom - arrowHeight,
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.right,
            rect.bottom - arrowHeight,
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
      );

    double arrowXCenter = rect.center.dx + arrowOffset;

    path.moveTo(arrowXCenter - arrowWidth / 2, rect.bottom - arrowHeight);
    path.lineTo(arrowXCenter, rect.bottom);
    path.lineTo(arrowXCenter + arrowWidth / 2, rect.bottom - arrowHeight);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
