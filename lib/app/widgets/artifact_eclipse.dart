
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArtifactEclipse extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final String image;
  const ArtifactEclipse({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      bottom: bottom,
      right: right,
      child: SvgPicture.asset(
        image,
        width: width,
        height: height,
      ),
    );
  }
}
