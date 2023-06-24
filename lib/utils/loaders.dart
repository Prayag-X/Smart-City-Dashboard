import 'package:flutter/material.dart';

Future showMaskLoader(context) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: (builder) => const SizedBox(
        height: 70,
        width: 70,
        child: Center(child: CircularProgressIndicator())));

class LoaderCircular extends StatelessWidget {
  const LoaderCircular({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(),
      ),
    );
  }
}