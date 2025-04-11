import 'package:flutter/material.dart';
import 'package:mejoralo_cdt/ui/shared/theme/colors.dart';

class MCard extends StatelessWidget {
  const MCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: AppColors.fog,
      child: Padding(padding: const EdgeInsets.all(10), child: child),
    );
  }
}
