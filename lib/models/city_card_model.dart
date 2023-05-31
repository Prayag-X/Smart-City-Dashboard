class CityCardModel {
  String cityName;
  String country;
  String image;
  int number;
  Map<String, String> availableData;

  CityCardModel(
      {required this.cityName,
      required this.country,
      required this.image,
      required this.number,
      required this.availableData});
}
