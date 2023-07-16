import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../../constants/constants.dart';
import '../../../providers/data_providers.dart';
import '../../../connections/ssh.dart';
import '../../../providers/settings_providers.dart';

class GoogleMapPart extends ConsumerStatefulWidget {
  const GoogleMapPart({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RightPanelState();
}

class _RightPanelState extends ConsumerState<GoogleMapPart> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition initialMapPosition;
  late CameraPosition newMapPosition;

  @override
  void initState() {
    super.initState();
    initialMapPosition = CameraPosition(
      target: ref.read(cityDataProvider)!.location,
      zoom: 11,
    );
    newMapPosition = initialMapPosition;
    SSH(ref: ref).flyTo(
        initialMapPosition.target.latitude,
        initialMapPosition.target.longitude,
        initialMapPosition.zoom.zoomLG,
        initialMapPosition.tilt,
        initialMapPosition.bearing);
  }

  @override
  Widget build(BuildContext context) {
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    MapType mapType = ref.watch(mapTypeProvider);
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Const.animationDuration,
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: Const.animationDistance,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            SizedBox(
              height: (screenSize(context).height - Const.appBarHeight) / 2 -
                  25 -
                  Const.dashboardUISpacing,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
                child: GoogleMap(
                  mapType: mapType,
                  initialCameraPosition: initialMapPosition,
                  onMapCreated: (GoogleMapController controller) =>
                      _controller.complete(controller),
                  onCameraMove: (position) =>
                      setState(() => newMapPosition = position),
                  onCameraIdle: () async => await SSH(ref: ref).flyTo(
                      newMapPosition.target.latitude,
                      newMapPosition.target.longitude,
                      newMapPosition.zoom.zoomLG,
                      newMapPosition.tilt,
                      newMapPosition.bearing),
                ),
              ),
            ),
            Const.dashboardUISpacing.ph,
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
                border: Border.all(
                  color: highlightColor,
                  width: 2.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      ref.read(mapTypeProvider.notifier).state = MapType.hybrid;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: mapType == MapType.hybrid
                            ? highlightColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(Const.dashboardUIRoundness - 3),
                            bottomLeft: Radius.circular(
                                Const.dashboardUIRoundness - 3)),
                      ),
                      child: Center(
                          child: Text(
                        translate('dashboard.map_type.hybrid'),
                        style: textStyleNormal.copyWith(
                            color: oppositeColor,
                            fontSize: Const.dashboardTextSize - 2),
                      )),
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      ref.read(mapTypeProvider.notifier).state = MapType.normal;
                    },
                    child: Container(
                      color: mapType == MapType.normal
                          ? highlightColor
                          : Colors.transparent,
                      child: Center(
                          child: Text(
                        translate('dashboard.map_type.normal'),
                        style: textStyleNormal.copyWith(
                            color: oppositeColor,
                            fontSize: Const.dashboardTextSize - 2),
                      )),
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      ref.read(mapTypeProvider.notifier).state =
                          MapType.terrain;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: mapType == MapType.terrain
                            ? highlightColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topRight:
                                Radius.circular(Const.dashboardUIRoundness - 3),
                            bottomRight: Radius.circular(
                                Const.dashboardUIRoundness - 3)),
                      ),
                      child: Center(
                          child: Text(
                        translate('dashboard.map_type.terrain'),
                        style: textStyleNormal.copyWith(
                            color: oppositeColor,
                            fontSize: Const.dashboardTextSize - 2),
                      )),
                    ),
                  )),
                ],
              ),
            ),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }
}
