import 'package:flutter/material.dart';

import 'screen_panel.dart';
import 'tab_panel.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
