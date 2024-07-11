import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ShimmerJobHorizontal extends StatelessWidget {
  bool hasShimer;
  ShimmerJobHorizontal({
    this.hasShimer = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 148, 148, 148),
      highlightColor: const Color.fromARGB(255, 102, 95, 95),
      child: Column(
        children: [
          Container(
            height: 126,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Visibility(
            visible: hasShimer,
            child: const SizedBox(height: 14),
          ),
          Visibility(
            visible: hasShimer,
            child: Container(
              height: 46,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
