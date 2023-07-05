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
    },
    'Drinking water quality': {
      'url':
          'https://data.cityofnewyork.us/api/views/bkwf-xfky/rows.csv?accessType=DOWNLOAD',
      'filename': 'water_quality.csv',
      'directory': 'NYC/environment'
    },
    'Natural gas consumption': {
      'url':
          'https://data.cityofnewyork.us/api/views/uedp-fegm/rows.csv?accessType=DOWNLOAD',
      'filename': 'gas_consumption.csv',
      'directory': 'NYC/environment'
    },
  };

  static List<Map<String, String>> nycEnvironment = [
    {
      'url':
          'https://data.cityofnewyork.us/api/geospatial/uyj8-7rv5?method=export&format=KML',
      'name': 'Sandy inundation zone',
      'size': '100 MB',
    },
    {
      'url':
          'https://data.cityofnewyork.us/api/geospatial/b9ze-z4u4?method=export&format=KML',
      'name': 'Citywide outfalls',
      'size': '4.20 MB',
    },
    {
      'url':
          'https://data.cityofnewyork.us/api/geospatial/ajyu-7sgg?method=export&format=KML',
      'name': 'Sea level rising',
      'size': '24 MB',
    },
  ];
}
