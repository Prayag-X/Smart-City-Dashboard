import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../constants/theme.dart';

class CityCard extends ConsumerWidget {
  const CityCard({
    Key? key,
    required this.name,
    required this.image,
    required this.country,
    required this.availableData,
  }) : super(key: key);

  final String name;
  final String image;
  final String country;
  final Map<String, String> availableData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Container(
        height: 200,
        width: screenSize(context).width - 500,
        color: darkenColor(Themes.darkHighlightColor, 0.05),
        child: Row(
          children: [
            ImageShower(logo: image, size: 200),
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
                    name,
                    style: textStyleBoldWhite.copyWith(fontSize: 30),
                  ),
                  5.ph,
                  Row(
                    children: [
                      const LogoShower(logo: ImageConst.markerLogo, size: 25),
                      Text(
                        country,
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
                        itemCount: availableData.length,
                        itemBuilder: (_, index) => Row(
                              children: [
                                5.pw,
                                LogoShower(
                                    logo: availableData.keys.elementAt(index),
                                    size: 20),
                                9.pw,
                                Text(
                                  availableData.values.elementAt(index),
                                  style: textStyleNormalWhite.copyWith(
                                      fontSize: 17),
                                )
                              ],
                            )),
                  ),
                  const SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
