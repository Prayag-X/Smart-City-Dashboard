import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../constants/constants.dart';
import '../../utils/helper.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
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
              children: [

              ])),
    );
  }
}
