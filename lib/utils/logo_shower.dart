import 'package:flutter/material.dart';

class AssetLogoShower extends StatelessWidget {
  const AssetLogoShower({
    Key? key,
    required this.logo,
    required this.size,
  }) : super(key: key);

  final String logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logo),
        ),
      ),
    );
  }
}

class LogoShower extends StatelessWidget {
  const LogoShower({
    Key? key,
    required this.logo,
    required this.size,
  }) : super(key: key);

  final ImageProvider<Object> logo;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: logo,
        ),
      ),
    );
  }
}


class AboutLogoShower extends StatelessWidget {
  const AboutLogoShower({
    Key? key,
    required this.logo,
    required this.height,
    required this.width,
  }) : super(key: key);

  final String logo;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(logo),
        ),
      ),
    );
  }
}

class ImageShower extends StatelessWidget {
  const ImageShower({
    Key? key,
    required this.logo,
    required this.size, this.curve,
  }) : super(key: key);

  final String logo;
  final double size;
  final BorderRadiusGeometry? curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: curve,
        image: DecorationImage(
          image: AssetImage(logo),
          fit: BoxFit.fitHeight
        ),
      ),
    );
  }
}
