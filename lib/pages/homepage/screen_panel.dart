import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepage/screen_body.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../widgets/helper.dart';

class ScreenPanel extends ConsumerStatefulWidget {
  const ScreenPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ScreenPanelState();
}

class _ScreenPanelState extends ConsumerState<ScreenPanel> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ScreenBody(),
        appBar(),
      ],
    );
  }

  Container appBar() {
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    return Container(
        height: Const.appBarHeight,
        color: Themes.darkColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TextConst.title,
                    style: textStyleBoldWhite.copyWith(
                      fontSize: 25
                    ),
                  ),
                  5.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isConnectedToLg ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(35.0)
                        ),
                      ),
                      5.pw,
                      Text(
                        isConnectedToLg ? TextConst.connected : TextConst.disconnected,
                        style: textStyleBold.copyWith(
                          color: isConnectedToLg ? Colors.green : Colors.red,
                          fontSize: 11
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 250,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mic,
                      color: Themes.darkWhiteColor,
                    ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Themes.darkWhiteColor, width: 3),
                          borderRadius: BorderRadius.circular(35.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:  BorderSide(
                              color: Themes.darkWhiteColor, width: 1),
                          borderRadius: BorderRadius.circular(35.0)),
                      hintText: TextConst.search,
                      hintStyle: textStyleNormal.copyWith(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13
                      )
                  ),
                  style: textStyleNormalWhite.copyWith(
                      fontSize: 13
                  ),
                  controller: searchController,
                ),
              ),
            ],
          ),
        ),
      );
  }
}


