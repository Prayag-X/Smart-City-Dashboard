class DownloadableKML {
  String url;
  String name;
  String size;
  String description;

  DownloadableKML({
    required this.url,
    required this.name,
    required this.size,
    this.description = '',
  });
}