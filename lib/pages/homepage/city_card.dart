import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/theme.dart';
import '../../models/city_card_model.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    Key? key,
    required this.cityData,
  }) : super(key: key);

  final CityCardModel cityData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: GestureDetector(
        onTap: () {
          ref.read(isHomePageProvider.notifier).state = false;
          ref.read(cityDataProvider.notifier).state = cityData;
        },
        child: SizedBox(
          height: 200+15,
          width: screenSize(context).width - 500+15,
          child: Stack(
            children: [
              Positioned(
                top: 15.0,
                left: 15.0,
                child: Container(
                  height: 200,
                  width: screenSize(context).width - 500,
                  color: lightenColor(Themes.darkHighlightColor, 0.05),
                ),
              ),
              Container(
                height: 200,
                width: screenSize(context).width - 500,
                color: darkenColor(Themes.darkHighlightColor, 0.05),
                child: Row(
                  children: [
                    ImageShower(logo: cityData.image, size: 200),
                    20.pw,
                    SizedBox(
                      width: screenSize(context).width - 960,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TextConst.smartCity,
                            style: textStyleNormal.copyWith(
                                fontSize: 14, color: Colors.white.withOpacity(0.6)),
                          ),
                          Text(
                            cityData.cityName,
                            style: textStyleBoldWhite.copyWith(fontSize: 30),
                          ),
                          5.ph,
                          Row(
                            children: [
                              const LogoShower(logo: ImageConst.markerLogo, size: 25),
                              Text(
                                cityData.country,
                                style: textStyleNormalWhite.copyWith(fontSize: 20),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      indent: 15,
                      endIndent: 15,
                    ),
                    5.pw,
                    SizedBox(
                      height: 150,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TextConst.availableData,
                            style: textStyleNormal.copyWith(
                                fontSize: 15, color: Colors.white.withOpacity(0.6)),
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                                itemCount: cityData.availableData.length,
                                itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Row(
                                        children: [
                                          5.pw,
                                          LogoShower(
                                              logo: cityData.availableData.keys.elementAt(index),
                                              size: 15),
                                          9.pw,
                                          Text(
                                            cityData.availableData.values.elementAt(index),
                                            style: textStyleNormalWhite.copyWith(
                                                fontSize: 17),
                                          )
                                        ],
                                      ),
                                )),
                          ),
                          const SizedBox.shrink()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
