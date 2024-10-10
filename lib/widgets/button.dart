import 'package:flutter/material.dart';
import 'package:sport60/widgets/shadow_painter.dart';

class CustomButton extends StatelessWidget {
  final void Function() onClick;
  final String heroTag;
  final double width;
  final double height;
  final Decoration? decoration;
  final ShadowPainter? shadowPainter;
  final bool noAnimation;
  final Widget? child;

  const CustomButton({
    super.key,
    required this.onClick,
    this.child,
    this.decoration,
    this.shadowPainter,
    required this.heroTag,
    this.width = 50,
    this.height = 50,
    this.noAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      shadowPainter != null
          ? CustomPaint(
              painter: shadowPainter,
              child: SizedBox(
                width: width,
                height: height,
              ),
            )
          : SizedBox(
              width: width,
              height: height,
            ),
      SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: decoration,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: onClick,
            heroTag: heroTag,
            focusColor: noAnimation ? Colors.transparent : null,
            splashColor: noAnimation ? Colors.transparent : null,
            hoverColor: noAnimation ? Colors.transparent : null,
            highlightElevation: noAnimation ? 0 : null,
            focusElevation: noAnimation ? 0 : null,
            hoverElevation: noAnimation ? 0 : null,
            disabledElevation: noAnimation ? 0 : null,
            backgroundColor: Colors.transparent,
            child: Center(child: child),
          ),
        ),
      ),
    ]);
  }
}
