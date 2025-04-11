import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MShimmer extends StatelessWidget {
  const MShimmer({super.key, required this.child, required this.isLoading});

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: child,
      );
    }
    return child;
  }
}
