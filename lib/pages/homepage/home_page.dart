import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/constants/available_cities.dart';
import 'package:smart_city_dashboard/pages/homepage/city_card.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: SizedBox(
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
