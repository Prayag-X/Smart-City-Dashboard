import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/constants.dart';
import '../../providers/settings_providers.dart';
import '../../utils/helper.dart';

class HelpPage extends ConsumerWidget {
  HelpPage({super.key});

  final double helpPageImageHeight = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    final TextStyle helpPageTextStyle =
        textStyleNormal.copyWith(color: oppositeColor, fontSize: 20);
    double spacing = Const.dashboardUISpacing * 2;
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Const.appBarHeight.ph,
            HelpPageSections(
              number: 0,
              children: [
                HelpPageTitleContainer(
                  title: translate('help_page.nav_title'),
                  key: ref.read(helpPageKeysProvider)[0],
                ),
                spacing.ph,
                HelpPageContainer(children: [
                  HelpLogoShower(
                    logo: ImageConst.nav1,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                  Expanded(
                      child: Text(translate('help_page.nav1'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle))
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.nav2'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  HelpLogoShower(
                    logo: ImageConst.nav2,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  HelpLogoShower(
                    logo: ImageConst.tab1,
                    height: helpPageImageHeight,
                    width: 120,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: oppositeColor,
                    size: 50,
                  ),
                  HelpLogoShower(
                    logo: ImageConst.tab2,
                    height: helpPageImageHeight,
                    width: 120,
                  ),
                  Expanded(
                      child: Text(translate('help_page.tab'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                spacing.ph,
                spacing.ph,
                spacing.ph,
              ],
            ),
            HelpPageSections(
              number: 1,
              children: [
                HelpPageTitleContainer(
                  title: translate('help_page.app_bar_title'),
                  key: ref.read(helpPageKeysProvider)[1],
                ),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.app_bar'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  const HelpLogoShower(
                    logo: ImageConst.appBar,
                    height: 80,
                    width: 370,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  HelpLogoShower(
                    logo: ImageConst.search,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                  Expanded(
                      child: Text(translate('help_page.search'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                spacing.ph,
                spacing.ph,
                spacing.ph,
              ],
            ),
            HelpPageSections(
              number: 2,
              children: [
                HelpPageTitleContainer(
                  title: translate('help_page.settings_title'),
                  key: ref.read(helpPageKeysProvider)[2],
                ),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.settings'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  const HelpLogoShower(
                    logo: ImageConst.settings1,
                    height: 160,
                    width: 250,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: oppositeColor,
                    size: 50,
                  ),
                  const HelpLogoShower(
                    logo: ImageConst.settings2,
                    height: 160,
                    width: 250,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  const HelpLogoShower(
                    logo: ImageConst.theme,
                    height: 170,
                    width: 500,
                  ),
                  Expanded(
                      child: Text(translate('help_page.settings_theme'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                spacing.ph,
                spacing.ph,
                spacing.ph,
              ],
            ),
            HelpPageSections(
              number: 3,
              children: [
                HelpPageTitleContainer(
                  title: translate('help_page.city_page_title'),
                  key: ref.read(helpPageKeysProvider)[3],
                ),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.feature1'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  HelpLogoShower(
                    logo: ImageConst.feature1,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  HelpLogoShower(
                    logo: ImageConst.feature2,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                  Expanded(
                      child: Text(translate('help_page.feature2'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.feature3'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  HelpLogoShower(
                    logo: ImageConst.feature3,
                    height: helpPageImageHeight,
                    width: 400,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  HelpLogoShower(
                    logo: ImageConst.feature4,
                    height: helpPageImageHeight,
                    width: 320,
                  ),
                  Expanded(
                      child: Text(translate('help_page.feature4'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.content'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  const HelpLogoShower(
                    logo: ImageConst.content1,
                    height: 160,
                    width: 250,
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: oppositeColor,
                    size: 50,
                  ),
                  const HelpLogoShower(
                    logo: ImageConst.content2,
                    height: 160,
                    width: 250,
                  ),
                ]),
                spacing.ph,
                spacing.ph,
                spacing.ph,
                spacing.ph,
              ],
            ),
            HelpPageSections(
              number: 4,
              children: [
                HelpPageTitleContainer(
                  title: translate('help_page.visualizer_page_title'),
                  key: ref.read(helpPageKeysProvider)[4],
                ),
                spacing.ph,
                HelpPageContainer(children: [
                  const HelpLogoShower(
                    logo: ImageConst.visualizer1,
                    height: 50,
                    width: 400,
                  ),
                  Expanded(
                      child: Text(translate('help_page.visualizer1'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.visualizer2'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  const HelpLogoShower(
                    logo: ImageConst.visualizer2,
                    height: 100,
                    width: 450,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  const HelpLogoShower(
                    logo: ImageConst.visualizer3,
                    height: 50,
                    width: 450,
                  ),
                  Expanded(
                      child: Text(translate('help_page.visualizer3'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.visualizer4'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  const HelpLogoShower(
                    logo: ImageConst.visualizer4,
                    height: 130,
                    width: 300,
                  ),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  const HelpLogoShower(
                    logo: ImageConst.visualizer5,
                    height: 35,
                    width: 450,
                  ),
                  Expanded(
                      child: Text(translate('help_page.visualizer5'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                ]),
                spacing.ph,
                HelpPageContainer(children: [
                  Expanded(
                      child: Text(translate('help_page.visualizer6'),
                          textAlign: TextAlign.justify,
                          style: helpPageTextStyle)),
                  HelpLogoShower(
                    logo: ImageConst.visualizer6,
                    height: helpPageImageHeight,
                    width: 250,
                  ),
                ]),
                spacing.ph,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HelpPageDivider extends ConsumerWidget {
  const HelpPageDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Divider(
        color: oppositeColor,
      ),
    );
  }
}

class HelpPageContainer extends ConsumerWidget {
  const HelpPageContainer({super.key, required this.children});
  final List<Widget> children;
  final double helpPageImageHeight = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
      height: helpPageImageHeight,
      decoration: BoxDecoration(
        color: darkenColor(highlightColor, 0.07),
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

class HelpPageTitleContainer extends ConsumerWidget {
  const HelpPageTitleContainer({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color highlightColor = ref.watch(highlightColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
        color: lightenColor(highlightColor),
      ),
      child: Center(
        child: Text(
          title,
          style: textStyleBold.copyWith(color: oppositeColor, fontSize: 40),
        ),
      ),
    );
  }
}

class HelpPageSections extends ConsumerWidget {
  const HelpPageSections({
    super.key,
    required this.number,
    required this.children,
  });
  final int number;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VisibilityDetector(
      key: GlobalKey(),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          ref.read(subTabProvider.notifier).state = number;
        }
      },
      child: AnimationLimiter(
        child: Column(
            children: AnimationConfiguration.toStaggeredList(
                duration: Const.animationDuration,
                childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: children)),
      ),
    );
  }
}
