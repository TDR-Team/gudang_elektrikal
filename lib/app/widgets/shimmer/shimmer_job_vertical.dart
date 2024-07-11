import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerJobVertical extends StatelessWidget {
  const ShimmerJobVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 148, 148, 148),
      highlightColor: const Color.fromARGB(255, 102, 95, 95),
      child: Container(
        width: 120,
        height: 166,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
