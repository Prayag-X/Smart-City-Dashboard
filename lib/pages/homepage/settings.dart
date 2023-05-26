import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city_dashboard/constants/available_data.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/kml_makers/image_shower.dart';
import 'package:smart_city_dashboard/pages/homepage/city_card.dart';
import 'package:smart_city_dashboard/providers/settings_providers.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../providers/page_providers.dart';
import '../../ssh_lg/ssh.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  TextEditingController ipController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController portController = TextEditingController(text: '');
  TextEditingController rigsController = TextEditingController(text: '');
  late SharedPreferences prefs;

  setSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', ipController.text);
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setInt('port', int.parse(portController.text));
    await prefs.setInt('rigs', int.parse(rigsController.text));
    ref.read(ipProvider.notifier).state = ipController.text;
    ref.read(usernameProvider.notifier).state = usernameController.text;
    ref.read(passwordProvider.notifier).state = passwordController.text;
    ref.read(portProvider.notifier).state = int.parse(portController.text);
    setRigs(int.parse(rigsController.text), ref);
  }

  initTextControllers() {
    setState(() {
      ipController.text = ref.read(ipProvider);
      usernameController.text = ref.read(usernameProvider);
      passwordController.text = ref.read(passwordProvider);
      portController.text = ref.read(portProvider).toString();
      rigsController.text = ref.read(rigsProvider).toString();
    });
  }

  @override
  void initState() {
    super.initState();
    initTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFields(
          icon: Icons.network_check_rounded,
          hintText: 'IP address',
          controller: ipController,
        ),
        TextFormFields(
          icon: Icons.person,
          hintText: 'LG Username',
          controller: usernameController,
        ),
        TextFormFields(
          icon: Icons.key_rounded,
          hintText: 'LG Password',
          controller: passwordController,
        ),
        TextFormFields(
          icon: Icons.key_rounded,
          hintText: 'SSH Port',
          controller: portController,
        ),
        TextFormFields(
          icon: Icons.key_rounded,
          hintText: 'No. of LG rigs',
          controller: rigsController,
        ),
        20.ph,
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF3F475C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.blue))),
          onPressed: () async => await setSharedPrefs(),
          child: SizedBox(
            height: 50,
            width: screenSize(context).width - 600,
            child: Center(
              child: Text(
                TextConst.save,
                style: textStyleBoldWhite.copyWith(fontSize: 15),
              ),
            ),
          ),
        ),
        20.ph,
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF3F475C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.blue))),
          onPressed: () async {
            await SSH(ref: ref).connect();
            await SSH(ref: ref).setRefresh();
            await SSH(ref: ref).renderInSlave(
                ref.read(leftmostRigProvider),
                ImageShower.showImage(
                    'https://www.google.com/search?q=images&rlz=1C1CHBD_enIN925IN925&sxsrf=APwXEddNoWg92Jj7e7atQCVBDWEKKRlXog:1684874055074&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjvz6z8pIz_AhViVPUHHad6DN0Q_AUoAXoECAEQAw&biw=1536&bih=722&dpr=1.25#imgrc=nwiTKnJXTwcwcM'));

          },
          child: SizedBox(
            height: 50,
            width: screenSize(context).width - 600,
            child: Center(
              child: Text(
                TextConst.connect,
                style: textStyleBoldWhite.copyWith(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextFormFields extends StatelessWidget {
  const TextFormFields({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData icon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: screenSize(context).width - 420,
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            labelText: hintText,
            labelStyle: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffffffff), width: 1),
            ),
          ),
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          controller: controller,
        ),
      ),
    );
  }
}
