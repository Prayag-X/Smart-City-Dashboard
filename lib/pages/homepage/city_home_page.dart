import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/available_cities.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/city_card.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

class CityHomePage extends StatelessWidget {
  const CityHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Container(
        height: screenSize(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: CityCardData.availableCities
                .map((city) => CityCard(
                      cityData: city,
                    ))
                .toList()),
      ),
    );
  }
}
