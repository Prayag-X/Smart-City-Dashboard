import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/constants.dart';
import '../../constants/theme.dart';

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
    double? loadingPercentage = ref.watch(loadingPercentageProvider);
    return Column(
      children: [
        Container(
          height: Const.appBarHeight - 10,
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
                          fontSize: Const.appBarTextSize + 10),
                    ),
                    5.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Const.appBarTextSize - 7,
                          height: Const.appBarTextSize - 7,
                          decoration: BoxDecoration(
                              color: isConnectedToInternet
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(35.0)),
                        ),
                        5.pw,
                        Text(
                          isConnectedToInternet
                              ? TextConst.online
                              : TextConst.offline,
                          style: textStyleBold.copyWith(
                              color: isConnectedToInternet
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: Const.appBarTextSize - 6),
                        ),
                        20.pw,
                        Container(
                          width: Const.appBarTextSize - 7,
                          height: Const.appBarTextSize - 7,
                          decoration: BoxDecoration(
                              color:
                                  isConnectedToLg ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(35.0)),
                        ),
                        5.pw,
                        Text(
                          isConnectedToLg
                              ? TextConst.connected
                              : TextConst.disconnected,
                          style: textStyleBold.copyWith(
                              color:
                                  isConnectedToLg ? Colors.green : Colors.red,
                              fontSize: Const.appBarTextSize - 6),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 350,
                  height: Const.appBarHeight - 30,
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
                            borderSide: BorderSide(
                                color: Themes.darkWhiteColor, width: 1),
                            borderRadius: BorderRadius.circular(35.0)),
                        hintText: TextConst.search,
                        hintStyle: textStyleNormal.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16)),
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
            child: isLoading
                ? LinearProgressIndicator(
                    value: loadingPercentage != -1 ? loadingPercentage : null,
                    backgroundColor: Themes.darkColor,
                    color: loadingPercentage == null
                        ? loadingPercentage != -1
                            ? lightenColor(Themes.darkHighlightColor, 0.2)
                            : Colors.green
                        : Colors.green,
                  )
                : const SizedBox.shrink()),
        7.ph
      ],
    );
  }
}
