import 'dart:async';

import 'package:features_tour/features_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/text_styles.dart';
import '../../../utils/extensions.dart';
import '../../../utils/helper.dart';
import '../../../constants/constants.dart';
import '../../../constants/theme.dart';
import '../../../providers/data_providers.dart';
import '../../../connections/ssh.dart';
import '../../../providers/page_providers.dart';
import '../../../providers/settings_providers.dart';
import '../../panels/feature_tour_widget.dart';

class GoogleMapPart extends ConsumerStatefulWidget {
  const GoogleMapPart(
      {Key? key, this.visualizer = false, this.showOrbit = true})
      : super(key: key);

  final bool visualizer;
  final bool showOrbit;

  @override
  ConsumerState createState() => _RightPanelState();
}

class _RightPanelState extends ConsumerState<GoogleMapPart> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition initialMapPosition;
  late CameraPosition newMapPosition;

  bool orbitPlaying = false;

  orbitPlay() async {
    setState(() {
      orbitPlaying = true;
    });
    SSH(ref: ref).flyTo(context, newMapPosition.target.latitude,
        newMapPosition.target.longitude, Const.appZoomScale.zoomLG, 0, 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int i = 0; i <= 360; i += 10) {
      if (!mounted) {
        return;
      }
      if (!orbitPlaying) {
        break;
      }
      SSH(ref: ref).flyToOrbit(
          context,
          newMapPosition.target.latitude,
          newMapPosition.target.longitude,
          Const.orbitZoomScale.zoomLG,
          60,
          i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (!mounted) {
      return;
    }
    SSH(ref: ref).flyTo(context, newMapPosition.target.latitude,
        newMapPosition.target.longitude, Const.appZoomScale.zoomLG, 0, 0);
    setState(() {
      orbitPlaying = false;
    });
  }

  orbitStop() async {
    setState(() {
      orbitPlaying = false;
    });
    SSH(ref: ref).flyTo(context, newMapPosition.target.latitude,
        newMapPosition.target.longitude, Const.appZoomScale.zoomLG, 0, 0);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((x) async {
      ref.read(playingGlobalTourProvider.notifier).state = false;
    });
    if (widget.visualizer) {
      initialMapPosition = const CameraPosition(
        target: LatLng(0, 0),
        zoom: 0,
      );
    } else {
      initialMapPosition = CameraPosition(
        target: ref.read(cityDataProvider)!.location,
        zoom: Const.appZoomScale,
      );
    }

    newMapPosition = initialMapPosition;
    SSH(ref: ref).flyTo(
        context,
        initialMapPosition.target.latitude,
        initialMapPosition.target.longitude,
        initialMapPosition.zoom.zoomLG,
        initialMapPosition.tilt,
        initialMapPosition.bearing);
  }

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    MapType mapType = ref.watch(mapTypeProvider);
    FeaturesTourController featuresTourDashboardController =
        ref.watch(featureTourControllerDashboardProvider);
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
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    GoogleMap(
                        mapType: mapType,
                        initialCameraPosition: initialMapPosition,
                        onMapCreated: (GoogleMapController controller) =>
                            _controller.complete(controller),
                        onCameraMove: (position) =>
                            setState(() => newMapPosition = position),
                        onCameraIdle: () async {
                          await orbitStop();
                          if (!mounted) {
                            return;
                          }
                          await SSH(ref: ref).flyTo(
                              context,
                              newMapPosition.target.latitude,
                              newMapPosition.target.longitude,
                              newMapPosition.zoom.zoomLG,
                              newMapPosition.tilt,
                              newMapPosition.bearing);
                        }),
                    widget.showOrbit
                        ? FeaturesTour(
                            index: 4,
                            controller: featuresTourDashboardController,
                            introduce: FeatureTourContainer(
                              text: translate('tour.d4'),
                            ),
                            introduceConfig: IntroduceConfig.copyWith(
                              quadrantAlignment: QuadrantAlignment.left,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(300),
                                    )),
                                onPressed: () async {
                                  if (!isConnectedToLg) {
                                    showSnackBar(
                                        context: context,
                                        message: translate(
                                            'settings.connection_required'));
                                    return;
                                  }
                                  if (orbitPlaying) {
                                    await orbitStop();
                                  } else {
                                    await orbitPlay();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 18),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        orbitPlaying
                                            ? Icons.stop_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.black.withOpacity(0.8),
                                        size: Const.dashboardTextSize + 4,
                                      ),
                                      3.pw,
                                      Text(
                                        orbitPlaying
                                            ? translate('dashboard.stop_orbit')
                                            : translate('dashboard.play_orbit'),
                                        style: textStyleBold.copyWith(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize:
                                                Const.dashboardTextSize + 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Const.dashboardUISpacing.ph,
            FeaturesTour(
              index: 5,
              controller: featuresTourDashboardController,
              introduce: FeatureTourContainer(
                text: translate('tour.d5'),
              ),
              introduceConfig: IntroduceConfig.copyWith(
                quadrantAlignment: QuadrantAlignment.left,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Const.dashboardUIRoundness),
                  border: Border.all(
                    color: themes.highlightColor,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        ref.read(mapTypeProvider.notifier).state =
                            MapType.hybrid;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: mapType == MapType.hybrid
                              ? themes.highlightColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Const.dashboardUIRoundness - 3),
                              bottomLeft: Radius.circular(
                                  Const.dashboardUIRoundness - 3)),
                        ),
                        child: Center(
                            child: Text(
                          translate('dashboard.map_type.hybrid'),
                          style: textStyleNormal.copyWith(
                              color: themes.oppositeColor,
                              fontSize: Const.dashboardTextSize - 2),
                        )),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        ref.read(mapTypeProvider.notifier).state =
                            MapType.normal;
                      },
                      child: Container(
                        color: mapType == MapType.normal
                            ? themes.highlightColor
                            : Colors.transparent,
                        child: Center(
                            child: Text(
                          translate('dashboard.map_type.normal'),
                          style: textStyleNormal.copyWith(
                              color: themes.oppositeColor,
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
                              ? themes.highlightColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  Const.dashboardUIRoundness - 3),
                              bottomRight: Radius.circular(
                                  Const.dashboardUIRoundness - 3)),
                        ),
                        child: Center(
                            child: Text(
                          translate('dashboard.map_type.terrain'),
                          style: textStyleNormal.copyWith(
                              color: themes.oppositeColor,
                              fontSize: Const.dashboardTextSize - 2),
                        )),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }
}
