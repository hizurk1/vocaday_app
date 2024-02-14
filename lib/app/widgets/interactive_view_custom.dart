import 'package:flutter/material.dart';

class InteractiveViewerCustom extends StatefulWidget {
  const InteractiveViewerCustom({
    super.key,
    required this.child,
    this.maxZoom = 3.0,
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.duration = Durations.long2,
  });

  final double maxZoom;
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  State<InteractiveViewerCustom> createState() =>
      _InteractiveViewerCustomState();
}

class _InteractiveViewerCustomState extends State<InteractiveViewerCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TransformationController _transformationController;
  late Animation<Matrix4> _zoomAnimation;

  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        _transformationController.value = _zoomAnimation.value;
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    Matrix4 endMatrix;
    Offset position = _doubleTapDetails!.localPosition;

    if (_transformationController.value.isIdentity()) {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(widget.maxZoom);
    } else {
      endMatrix = Matrix4.identity();
    }

    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurveTween(curve: widget.curve).animate(_animationController),
    );

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        clipBehavior: Clip.none,
        child: widget.child,
      ),
    );
  }
}
