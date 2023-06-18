import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/pages/homepages/about_page.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard.dart';
import 'package:smart_city_dashboard/pages/homepages/help_page.dart';
import 'package:smart_city_dashboard/pages/homepages/settings_page.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';
import '../../providers/page_providers.dart';
import '../homepages/home_page.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AppBarState();
}

class _AppBarState extends ConsumerState<CustomAppBar> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    bool isConnectedToLg = ref.watch(isConnectedToLGProvider);
    bool isConnectedToInternet = ref.watch(isConnectedToInternetProvider);
    bool isLoading = ref.watch(isLoadingProvider);
    return Column(
      children: [
        Container(
          height: Const.appBarHeight-10,
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
                      style: textStyleBoldWhite.copyWith(fontSize: 30),
                    ),
                    5.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                              color: isConnectedToInternet ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(35.0)),
                        ),
                        5.pw,
                        Text(
                          isConnectedToInternet
                              ? TextConst.online
                              : TextConst.offline,
                          style: textStyleBold.copyWith(
                              color: isConnectedToInternet ? Colors.green : Colors.red,
                              fontSize: 14),
                        ),
                        20.pw,
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                              color: isConnectedToLg ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(35.0)),
                        ),
                        5.pw,
                        Text(
                          isConnectedToLg
                              ? TextConst.connected
                              : TextConst.disconnected,
                          style: textStyleBold.copyWith(
                              color: isConnectedToLg ? Colors.green : Colors.red,
                              fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 350,
                  height: Const.appBarHeight-60,
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mic,
                          color: Themes.darkWhiteColor,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Themes.darkWhiteColor, width: 3),
                            borderRadius: BorderRadius.circular(35.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Themes.darkWhiteColor, width: 1),
                            borderRadius: BorderRadius.circular(35.0)),
                        hintText: TextConst.search,
                        hintStyle: textStyleNormal.copyWith(
                            color: Colors.white.withOpacity(0.5), fontSize: 16)),
                    style: textStyleNormalWhite.copyWith(fontSize: 16),
                    controller: searchController,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
            height: 3,
            child: isLoading ? LinearProgressIndicator(
              backgroundColor: Themes.darkColor,
              color: lightenColor(Themes.darkHighlightColor, 0.2),
            ) : const SizedBox.shrink()
        ),
        7.ph
      ],
    );
  }
}
