import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';

import '../../constants/constants.dart';
import '../../providers/settings_providers.dart';

class FeatureTourContainer extends ConsumerWidget {
  const FeatureTourContainer({
    super.key,
    this.width = 350,
    required this.text,
  });

  final double width;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: width,
          color: highlightColor.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12),
            child: Text(text,
                style: textStyleNormal.copyWith(
                    fontSize: 19, color: oppositeColor)),
          ),
        ),
      ),
    );
  }
}
