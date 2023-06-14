import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/available_cities.dart';
import 'package:smart_city_dashboard/pages/homepages/city_card.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../constants/constants.dart';
import '../../providers/settings_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: SizedBox(
        height: screenSize(context).height,
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
                duration: Const.animationDuration,
                childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: Const.animationDistance,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: CityCardData.availableCities
                    .map((city) => CityCard(
                          cityData: city,
                        ))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
