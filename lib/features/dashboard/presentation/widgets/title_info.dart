import 'package:flutter/material.dart';
import 'package:mejoralo_cdt/ui/shared/theme/colors.dart';

enum TitleInfoTooltipPosition { up, down }

class TitleInfo extends StatelessWidget {
  const TitleInfo({
    super.key,
    required this.title,
    this.subTitle,
    this.tooltipPosition = TitleInfoTooltipPosition.down,
    this.useTooltip = false,
    this.tooltipMessage,
  });

  final String title;
  final String? subTitle;
  final TitleInfoTooltipPosition tooltipPosition;
  final bool useTooltip;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    final widget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                fontSize: 16,
              ),
            ),
            useTooltip
                ? Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: const Icon(
                    Icons.info_outline,

                    size: 16,
                    color: AppColors.lightGrey,
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
        subTitle != null
            ? Text(
              subTitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.darkColor.withAlpha(230),
              ),
            )
            : const SizedBox.shrink(),
      ],
    );
    if (useTooltip) {
      return Tooltip(
        message: tooltipMessage,
        verticalOffset: 10,
        enableTapToDismiss: true,
        padding: const EdgeInsets.all(10),
        showDuration: const Duration(seconds: 2),
        triggerMode: TooltipTriggerMode.tap,
        child: widget,
      );
    }
    return widget;
  }
}
