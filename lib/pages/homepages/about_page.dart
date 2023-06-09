import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
        child: SingleChildScrollView(
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
                          borderRadius:
                              BorderRadius.circular(Const.dashboardUIRoundness),
                          color: Themes.darkHighlightColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AssetLogoShower(
                                  logo: ImageConst.app, size: 140),
                              Text(
                                TextConst.title,
                                style:
                                    textStyleBoldWhite.copyWith(fontSize: 40),
                              ),
                              const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      30.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          AboutLogoShower(
                            logo: ImageConst.gsoc,
                            height: 100,
                            width: 200,
                          ),
                          AboutLogoShower(
                            logo: ImageConst.lgAbout,
                            height: 100,
                            width: 200,
                          ),
                          AboutLogoShower(
                            logo: ImageConst.flutter,
                            height: 100,
                            width: 230,
                          ),
                        ],
                      ),
                      50.ph,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          TextConst.aboutPageDescription,
                          textAlign: TextAlign.justify,
                          style: textStyleNormalWhite.copyWith(fontSize: 17),
                        ),
                      ),
                      30.ph,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UrlLauncher(
                                        text: TextConst.aboutPageGithub,
                                        url:
                                            'https://github.com/Prayag-X/Smart-City-Dashboard'),
                                    UrlLauncher(
                                        text: TextConst.aboutPageLicense,
                                        url:
                                            'https://github.com/Prayag-X/Smart-City-Dashboard/blob/main/LICENSE'),
                                    UrlLauncher(
                                        text: TextConst.aboutPageLGSite,
                                        url: 'https://www.liquidgalaxy.eu/'),
                                    UrlLauncher(
                                        text: TextConst.aboutPageLinkedin,
                                        url:
                                            'https://www.linkedin.com/in/prayag-biswas-293644215/'),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                                width: 60,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AboutText(
                                        text1: TextConst.aboutPageMadeBy,
                                        text2: TextConst.aboutPagePrayag),
                                    AboutText(
                                        text1: TextConst.aboutPageOrganisation,
                                        text2: TextConst.aboutPageLiquidGalaxy),
                                    AboutText(
                                        text1: TextConst.aboutPageOrgAdmin,
                                        text2: TextConst.aboutPageAndrew),
                                    AboutText(
                                        text1: TextConst.aboutPageMentor,
                                        text2: TextConst.aboutPageMerul),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      30.ph,
                      Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            AboutLogoShower(
                              logo: ImageConst.lgEu,
                              height: 100,
                              width: 210,
                            ),
                            AboutLogoShower(
                              logo: ImageConst.lgLab,
                              height: 100,
                              width: 200,
                            ),
                            AboutLogoShower(
                              logo: ImageConst.gdg,
                              height: 100,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            AboutLogoShower(
                              logo: ImageConst.tic,
                              height: 80,
                              width: 120,
                            ),
                            AboutLogoShower(
                              logo: ImageConst.womenTechmakers,
                              height: 100,
                              width: 250,
                            ),
                            AboutLogoShower(
                              logo: ImageConst.parcLleida,
                              height: 100,
                              width: 200,
                            ),
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
        ));
  }
}

class UrlLauncher extends StatelessWidget {
  const UrlLauncher({super.key, required this.text, required this.url});

  final String text;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () async => await launchUrl(Uri.parse(url)),
      child: Text(
        text,
        style: textStyleNormal.copyWith(fontSize: 17, color: Colors.blue),
      ),
    );
  }
}

class AboutText extends StatelessWidget {
  const AboutText({super.key, required this.text1, required this.text2});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          style: textStyleNormal.copyWith(fontSize: 17, color: Colors.green),
        ),
        Text(
          ': ',
          style: textStyleNormal.copyWith(fontSize: 17, color: Colors.yellow),
        ),
        Text(
          text2,
          style: textStyleNormalWhite.copyWith(fontSize: 17),
        ),
      ],
    );
  }
}
