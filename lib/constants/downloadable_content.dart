class DownloadableContent {
  static generateFileName(Map<String, String> data) =>
      '${data['directory']}/${data['filename']}';

  static Map<String, Map<String, String>> content = {
    'Squirrel Data': {
      'url':
          'https://data.cityofnewyork.us/api/views/vfnx-vebw/rows.csv?accessType=DOWNLOAD',
      'filename': 'squirrel.csv',
      'directory': 'NYC/environment'
    },
    'Water Consumption': {
      'url':
          'https://data.cityofnewyork.us/api/views/ia2d-e54m/rows.csv?accessType=DOWNLOAD',
      'filename': 'water_consumption.csv',
      'directory': 'NYC/environment'
    }
  };

  static List<Map<String, String>> nycEnvironment = [
    {
      'url':
          'https://data.cityofnewyork.us/api/geospatial/uyj8-7rv5?method=export&format=KML',
      'name': 'Sandy Inundation Zone',
      'size': '100 MB',
    },
  ];
}
