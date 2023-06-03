import 'package:flutter/material.dart';

import 'panels/screen_panel.dart';
import 'panels/tab_panel.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          body: Row(
            children: const [
              TabPanel(),
              Expanded(
                  child: ScreenPanel()
              ),
            ],
          )
      ),
    );
  }
}
