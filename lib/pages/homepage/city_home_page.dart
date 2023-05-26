import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/available_data.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/city_card.dart';

class CityHomePage extends StatelessWidget {
  const CityHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CityCard(
            name: TextConst.bhubaneswar,
            image: ImageConst.bhubaneswar,
            country: TextConst.india,
            availableData: ViennaData.data
        ),
        CityCard(
            name: TextConst.bhubaneswar,
            image: ImageConst.bhubaneswar,
            country: TextConst.india,
            availableData: ViennaData.data
        ),
      ],
    );
  }
}