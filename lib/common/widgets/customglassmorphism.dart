import 'package:flutter/material.dart';
import 'dart:ui';

class GlassMorph extends StatelessWidget {
  final Widget child;
  const GlassMorph({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            //add gradient
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
            ),
            border: Border.all(
              width: 0,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
