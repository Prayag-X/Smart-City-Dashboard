import '../../models/downloadable_kml.dart';

class DownloadableContent {
  static generateFileName(Map<String, String> data) =>
      '${data['directory']}/${data['filename']}';

  static Map<String, Map<String, String>> content = {
    //NYC Environment
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

    //NYC Health
    'Covid cases NYC': {
      'url':
          'https://data.cityofnewyork.us/api/views/rc75-m7u3/rows.csv?accessType=DOWNLOAD',
      'filename': 'covid.csv',
      'directory': 'NYC/health'
    },
    'SARS CoV2': {
      'url':
          'https://data.cityofnewyork.us/api/views/f7dc-2q9f/rows.csv?accessType=DOWNLOAD',
      'filename': 'cov2.csv',
      'directory': 'NYC/health'
    },
    'Infant Mortality': {
      'url':
          'https://data.cityofnewyork.us/api/views/fcau-jc6k/rows.csv?accessType=DOWNLOAD',
      'filename': 'infant_mortality.csv',
      'directory': 'NYC/health'
    },
    'HIV diagnosis': {
      'url':
          'https://data.cityofnewyork.us/api/views/ykvb-493p/rows.csv?accessType=DOWNLOAD',
      'filename': 'hiv.csv',
      'directory': 'NYC/health'
    },

    //NYC Education
    'SAT result': {
      'url':
          'https://data.cityofnewyork.us/api/views/f9bf-2cp4/rows.csv?accessType=DOWNLOAD',
      'filename': 'sat.csv',
      'directory': 'NYC/education'
    },
    'Math result': {
      'url':
          'https://data.cityofnewyork.us/api/views/jufi-gzgp/rows.csv?accessType=DOWNLOAD',
      'filename': 'math.csv',
      'directory': 'NYC/education'
    },
    'Attendance': {
      'url':
          'https://data.cityofnewyork.us/api/views/7z8d-msnt/rows.csv?accessType=DOWNLOAD',
      'filename': 'attendance.csv',
      'directory': 'NYC/education'
    },
    'Bilingual program': {
      'url':
          'https://data.cityofnewyork.us/api/views/rrd7-vuvp/rows.csv?accessType=DOWNLOAD',
      'filename': 'bilingual.csv',
      'directory': 'NYC/education'
    },
  };

  static List<DownloadableKML> nycEnvironmentKml = [
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/uyj8-7rv5?method=export&format=KML',
        name: 'Sandy inundation zone',
        description:
            'Areas of New York City that were flooded as a result of Hurricane Sandy.',
        size: '100 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/b9ze-z4u4?method=export&format=KML',
        name: 'Citywide outfalls',
        size: '4.20 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/ajyu-7sgg?method=export&format=KML',
        name: 'Sea level rising',
        description:
            'This is the 500-Year Floodplain for the 2050s based on FEMAs Preliminary Work Map data and the New York Panel on Climate Changes 90th Percentile Projects for Sea-Level Rise (31 inches).',
        size: '24 MB'),
  ];

  static List<DownloadableKML> nycHealthKml = [
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/5p78-k3zm?method=export&format=KML',
        name: 'Health Areas',
        size: '4.45 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/b55q-34ps?method=export&format=KML',
        name: 'Health Center Districts',
        size: '3.31 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/mzbd-kucq?method=export&format=KML',
        name: 'Non-neighborhood places',
        size: '63.1 KB'),
  ];

  static List<DownloadableKML> nycEducationKml = [
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/r8nu-ymqj?method=export&format=KML',
        name: 'School Districts',
        size: '4.45 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/4kym-4xw5?method=export&format=KML',
        name: 'Colleges and Universities',
        size: '48.1 KB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/kuk3-ypca?method=export&format=KML',
        name: '2019-20 Elementary Zones',
        size: '2.78 MB'),
    DownloadableKML(
        url:
            'https://data.cityofnewyork.us/api/geospatial/jzhx-pept?method=export&format=KML',
        name: '2017-18 High School Zones',
        size: '828.3 KB'),
  ];
}
