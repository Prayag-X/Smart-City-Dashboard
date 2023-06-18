import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../models/city_card_model.dart';
import '../../providers/data_providers.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    Key? key,
    required this.cityData,
  }) : super(key: key);

  final CityCardModel cityData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = screenSize(context).height - 600;
    double width = screenSize(context).width - 400;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Const.homePageTextSize+5),
      child: GestureDetector(
        onTap: () {
          ref.read(isHomePageProvider.notifier).state = false;
          ref.read(cityDataProvider.notifier).state = cityData;
        },
        child: SizedBox(
          height: height+15,
          width: width+15,
          child: Stack(
            children: [
              Positioned(
                top: 15.0,
                left: 15.0,
                child: Container(
                  height: height,
                  width: width,
                  color: lightenColor(Themes.darkHighlightColor, 0.05),
                ),
              ),
              Container(
                height: height,
                width: width,
                color: darkenColor(Themes.darkHighlightColor, 0.05),
                child: Row(
                  children: [
                    ImageShower(logo: cityData.image, size: height),
                    Const.homePageTextSize.pw,
                    SizedBox(
                      width: width/2 - 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TextConst.smartCity,
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize-6, color: Colors.white.withOpacity(0.6)),
                          ),
                          Text(
                            cityData.cityName,
                            style: textStyleBoldWhite.copyWith(fontSize: Const.homePageTextSize+10),
                          ),
                          5.ph,
                          Row(
                            children: [
                              AssetLogoShower(logo: ImageConst.markerLogo, size: Const.homePageTextSize+5),
                              Text(
                                cityData.country,
                                style: textStyleNormalWhite.copyWith(fontSize: Const.homePageTextSize),
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
                      height: height-20,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TextConst.availableData,
                            style: textStyleNormal.copyWith(
                                fontSize: Const.homePageTextSize-5, color: Colors.white.withOpacity(0.6)),
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
                                          AssetLogoShower(
                                              logo: cityData.availableData.keys.elementAt(index),
                                              size: Const.homePageTextSize-5),
                                          9.pw,
                                          Text(
                                            cityData.availableData.values.elementAt(index),
                                            style: textStyleNormalWhite.copyWith(
                                                fontSize: Const.homePageTextSize-3),
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
