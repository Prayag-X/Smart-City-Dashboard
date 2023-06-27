class DownloadableContent {
  static generateFileName(Map<String, String> data) => '${data['directory']}/${data['filename']}';

  static Map<String, Map<String, String>> content = {
    'Squirrel Data': {
      'url': 'https://data.cityofnewyork.us/api/views/vfnx-vebw/rows.csv?accessType=DOWNLOAD',
      'filename': 'squirrel.csv',
      'directory': 'NYC/environment'
    },
    'Water Consumption': {
      'url': 'https://data.cityofnewyork.us/api/views/ia2d-e54m/rows.csv?accessType=DOWNLOAD',
      'filename': 'water_consumption.csv',
      'directory': 'NYC/environment'
    }
  };
}