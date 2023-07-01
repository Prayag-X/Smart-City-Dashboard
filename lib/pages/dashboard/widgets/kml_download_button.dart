import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';

class KmlDownloaderButton extends ConsumerWidget {
  const KmlDownloaderButton(this.data, this.index, {super.key});

  final Map<String, String> data;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int kmlClicked = ref.watch(kmlClickedProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: (){},
        child: Container(
          decoration: BoxDecoration(
            color: kmlClicked == index
                ? Themes.darkHighlightColor
                : null,
            borderRadius:
            BorderRadius.circular(Const.dashboardUIRoundness),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_downward_rounded,
                  size: 25,
                  color: Colors.blue,
                ),
                7.pw,
                Row(
                  children: [
                    Text(
                      data['size']!,
                      style: textStyleNormal.copyWith(
                          fontSize: 18, color: Colors.redAccent.withOpacity(0.7)),
                    ),
                    Text(
                      '  ${data['name']!}',
                      style: textStyleNormalWhite.copyWith(
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}