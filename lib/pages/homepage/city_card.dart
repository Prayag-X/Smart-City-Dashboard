import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        height: 170,
        width: 650,
        color: Color(0xFF2F3546),
        child: Row(
          children: [
            ImageShower(logo: image, size: 170),
            20.pw,
            SizedBox(
              width: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextConst.smartCity,
                    style: textStyleNormal.copyWith(
                        fontSize: 11, color: Colors.white.withOpacity(0.6)),
                  ),
                  Text(
                    name,
                    style: textStyleBoldWhite.copyWith(fontSize: 26),
                  ),
                  5.ph,
                  Row(
                    children: [
                      const LogoShower(logo: ImageConst.markerLogo, size: 20),
                      Text(
                        country,
                        style: textStyleNormalWhite.copyWith(fontSize: 15),
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
                        fontSize: 12, color: Colors.white.withOpacity(0.6)),
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                        itemCount: availableData.length,
                        itemBuilder: (_, index) => Row(
                              children: [
                                5.pw,
                                LogoShower(
                                    logo: availableData.keys.elementAt(index),
                                    size: 15),
                                9.pw,
                                Text(
                                  availableData.values.elementAt(index),
                                  style: textStyleNormalWhite.copyWith(
                                      fontSize: 14),
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
