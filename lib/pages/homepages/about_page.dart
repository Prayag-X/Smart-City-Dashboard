import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../providers/settings_providers.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
        child:
        Column(
          children: [
            Const.appBarHeight.ph,
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: Const.animationDuration,
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: -Const.animationDistance,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
                        color: Themes.darkHighlightColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            LogoShower(logo: AssetImage(ImageConst.appLogo), size: 140),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
