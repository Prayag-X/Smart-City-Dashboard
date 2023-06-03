import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../constants/constants.dart';
import '../../ssh_lg/ssh.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
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
    return Padding(
      padding: EdgeInsets.only(top: Const.appBarHeight),
      child: SizedBox(
        height: screenSize(context).height - Const.appBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox.shrink(),
            Container(
              width: (screenSize(context).width - Const.tabBarWidth) / 2,
              color: Colors.blue,
              child: Column(),
            ),
            Container(
              width: (screenSize(context).width - Const.tabBarWidth) / 2 - 40,
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(
                    height:
                        (screenSize(context).height - Const.appBarHeight) / 2,
                    child: GoogleMap(
                      mapType: MapType.hybrid,
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
                  )
                ],
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
