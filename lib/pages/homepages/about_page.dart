import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AssetLogoShower(logo: ImageConst.app, size: 140),
                              Text(
                                TextConst.title,
                                style: textStyleBoldWhite.copyWith(fontSize: 40),
                              ),
                              const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      30.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AboutLogoShower(logo: ImageConst.gsoc, height: 100, width: 200,),
                          AboutLogoShower(logo: ImageConst.lgAbout, height: 100, width: 200,),
                          AboutLogoShower(logo: ImageConst.flutter, height: 100, width: 230,),
                        ],
                      ),
                      500.ph,
                      Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AboutLogoShower(logo: ImageConst.lgEu, height: 100, width: 210,),
                            AboutLogoShower(logo: ImageConst.lgLab, height: 100, width: 200,),
                            AboutLogoShower(logo: ImageConst.gdg, height: 100, width: 200,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AboutLogoShower(logo: ImageConst.tic, height: 80, width: 120,),
                            AboutLogoShower(logo: ImageConst.womenTechmakers, height: 100, width: 250,),
                            AboutLogoShower(logo: ImageConst.parcLleida, height: 100, width: 200,),
                          ],
                        ),
                      ),
                      20.ph
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
