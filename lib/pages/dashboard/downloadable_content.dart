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

    //Charlotte production
    'Violent crimes': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/83fb31d4a9be463daa4f0dc37482c259_4/downloads/data?format=csv&spatialRefId=2264&where=1%3D1',
      'filename': 'crimes.csv',
      'directory': 'Charlotte/production'
    },
    'Public Requests': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/1469a8eb00424dd7a1804744ec116a99_2/downloads/data?format=csv&spatialRefId=2264&where=1%3D1',
      'filename': 'requests.csv',
      'directory': 'Charlotte/production'
    },

    //Charlotte misc
    'Calls for service': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/1c674f520cab46fca7bad37d9d045da3_0/downloads/data?format=csv&spatialRefId=2264&where=1%3D1',
      'filename': 'service_calls.csv',
      'directory': 'Charlotte/misc'
    },
    'Traffic stops': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/67b28a8ee2d2489f93ccf386b0e2afe1_14/downloads/data?format=csv&spatialRefId=3857&where=1%3D1',
      'filename': 'stops.csv',
      'directory': 'Charlotte/misc'
    },
    'Housing demand': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/5d33129a2eea43f2b19b5443907c2e7d_1/downloads/data?format=csv&spatialRefId=2264&where=1%3D1',
      'filename': 'demands.csv',
      'directory': 'Charlotte/misc'
    },

    //Seattle Finance
    'Fleet for auction': {
      'url':
          'https://data.seattle.gov/api/views/6gnm-7jex/rows.csv?accessType=DOWNLOAD',
      'filename': 'fleet.csv',
      'directory': 'Seattle/finance'
    },
    '2014 Endorsed budget': {
      'url':
          'https://data.seattle.gov/api/views/nrfc-hypb/rows.csv?accessType=DOWNLOAD',
      'filename': 'endorsed_budget.csv',
      'directory': 'Seattle/finance'
    },
    'Open Budget': {
      'url':
          'https://data.seattle.gov/api/views/3cfy-6eby/rows.csv?accessType=DOWNLOAD',
      'filename': 'open_budget.csv',
      'directory': 'Seattle/finance'
    },
    '2011-16 CIP': {
      'url':
          'https://data.seattle.gov/api/views/9689-kxj4/rows.csv?accessType=DOWNLOAD',
      'filename': 'cip.csv',
      'directory': 'Seattle/finance'
    },
    'Operating budget': {
      'url':
          'https://data.seattle.gov/api/views/8u2j-imqx/rows.csv?accessType=DOWNLOAD',
      'filename': 'operating_budget.csv',
      'directory': 'Seattle/finance'
    },
    '2019-20 Adopted Budget': {
      'url':
          'https://data.seattle.gov/api/views/rimb-6qnk/rows.csv?accessType=DOWNLOAD',
      'filename': 'adopted_budget.csv',
      'directory': 'Seattle/finance'
    },

    //Transport Data
    'Fretmont Cycle counter': {
      'url':
          'https://data.seattle.gov/api/views/65db-xm6k/rows.csv?accessType=DOWNLOAD',
      'filename': 'fretmont_counter.csv',
      'directory': 'Seattle/transport'
    },
    'Brodway Cycle counter': {
      'url':
          'https://data.seattle.gov/api/views/j4vh-b42a/rows.csv?accessType=DOWNLOAD',
      'filename': 'brodway_counter.csv',
      'directory': 'Seattle/transport'
    },
    'Westlake Cycle counter': {
      'url':
          'https://data.seattle.gov/api/views/675b-cqew/rows.csv?accessType=DOWNLOAD',
      'filename': 'westlake_counter.csv',
      'directory': 'Seattle/transport'
    },
    'Annual parking': {
      'url':
          'https://data.seattle.gov/api/views/7jzm-ucez/rows.csv?accessType=DOWNLOAD',
      'filename': 'annual_parking.csv',
      'directory': 'Seattle/transport'
    },
    'Traffic counts': {
      'url':
          'https://data.seattle.gov/api/views/xucb-vzhc/rows.csv?accessType=DOWNLOAD',
      'filename': 'traffic_count.csv',
      'directory': 'Seattle/transport'
    },
    'NBPD Bike count': {
      'url':
          'https://data.seattle.gov/api/views/ewwk-ty4e/rows.csv?accessType=DOWNLOAD',
      'filename': 'nbpd_bike_count.csv',
      'directory': 'Seattle/transport'
    },
    'Short Duration Bike count': {
      'url':
          'https://data.seattle.gov/api/views/m83s-wdbc/rows.csv?accessType=DOWNLOAD',
      'filename': 'short_duration_bike_count.csv',
      'directory': 'Seattle/transport'
    },
    'WAT 2017': {
      'url':
          'https://data.seattle.gov/api/views/q4zb-r3zn/rows.csv?accessType=DOWNLOAD',
      'filename': 'wat_2017.csv',
      'directory': 'Seattle/transport'
    },

    //Seattle Education
    'TSG Overall': {
      'url':
          'https://data.seattle.gov/api/views/f9zk-fa85/rows.csv?accessType=DOWNLOAD',
      'filename': 'tsg_overall.csv',
      'directory': 'Seattle/education'
    },
    'TSG domain': {
      'url':
          'https://data.seattle.gov/api/views/iv78-xwas/rows.csv?accessType=DOWNLOAD',
      'filename': 'tsg_domain.csv',
      'directory': 'Seattle/education'
    },
    'SPP enrollment': {
      'url':
          'https://data.seattle.gov/api/views/ix3q-qr7w/rows.csv?accessType=DOWNLOAD',
      'filename': 'spp_enrollment.csv',
      'directory': 'Seattle/education'
    },
    'SPP vs SPS': {
      'url':
          'https://data.seattle.gov/api/views/hk3p-ag4k/rows.csv?accessType=DOWNLOAD',
      'filename': 'spp_sps.csv',
      'directory': 'Seattle/education'
    },

    //Austin Environment
    'Imagine Austin Indicator': {
      'url':
          'https://data.austintexas.gov/api/views/apwj-7zty/rows.csv?accessType=DOWNLOAD',
      'filename': 'imagine_austin.csv',
      'directory': 'Austin/environment'
    },
    'CPI 3.8 Abuse': {
      'url':
          'https://data.texas.gov/api/views/v63e-6dss/rows.csv?accessType=DOWNLOAD',
      'filename': 'cpi38.csv',
      'directory': 'Austin/environment'
    },
    'Green Building Ratings': {
      'url':
          'https://data.austintexas.gov/api/views/dpvb-c5fy/rows.csv?accessType=DOWNLOAD',
      'filename': 'green_rating.csv',
      'directory': 'Austin/environment'
    },
    '2019 ECAD': {
      'url':
          'https://data.austintexas.gov/api/views/feiy-7jhe/rows.csv?accessType=DOWNLOAD',
      'filename': '2019_ecad.csv',
      'directory': 'Austin/environment'
    },
    'CPI 3.3 Abuse': {
      'url':
          'https://data.texas.gov/api/views/vzdd-cppz/rows.csv?accessType=DOWNLOAD',
      'filename': 'cpi33.csv',
      'directory': 'Austin/environment'
    },
    'Renewable Power Source': {
      'url':
          'https://data.austintexas.gov/api/views/7k3d-ry7d/rows.csv?accessType=DOWNLOAD',
      'filename': 'renewable_power.csv',
      'directory': 'Austin/environment'
    },
    'HEE5C': {
      'url':
          'https://data.austintexas.gov/api/views/ejk8-63sb/rows.csv?accessType=DOWNLOAD',
      'filename': 'heec5.csv',
      'directory': 'Austin/environment'
    },

    //Austin Health
    'SA4 Mental training': {
      'url':
          'https://data.austintexas.gov/api/views/xz2z-phib/rows.csv?accessType=DOWNLOAD',
      'filename': 'SA4.csv',
      'directory': 'Austin/health'
    },
    'SA5 Mental training': {
      'url':
          'https://data.austintexas.gov/api/views/iys6-c7vj/rows.csv?accessType=DOWNLOAD',
      'filename': 'SA5.csv',
      'directory': 'Austin/health'
    },
    'Food Inspection': {
      'url':
          'https://data.austintexas.gov/api/views/ecmv-9xxi/rows.csv?accessType=DOWNLOAD',
      'filename': 'food_inspection.csv',
      'directory': 'Austin/health'
    },
    'Below 65 no health insurance': {
      'url':
          'https://data.austintexas.gov/api/views/kuzb-i7x7/rows.csv?accessType=DOWNLOAD',
      'filename': 'health_insurance.csv',
      'directory': 'Austin/health'
    },
    'Creek lake good health': {
      'url':
          'https://data.austintexas.gov/api/views/773s-mqs2/rows.csv?accessType=DOWNLOAD',
      'filename': 'lake_health.csv',
      'directory': 'Austin/health'
    },
    'Bad mental health': {
      'url':
          'https://data.austintexas.gov/api/views/tncx-hyqy/rows.csv?accessType=DOWNLOAD',
      'filename': 'bad_mental_health.csv',
      'directory': 'Austin/health'
    },

    //Austin Transport
    'EMS Transport': {
      'url':
          'https://data.austintexas.gov/api/views/jtkc-5pgh/rows.csv?accessType=DOWNLOAD',
      'filename': 'ems_transport.csv',
      'directory': 'Austin/transport'
    },
    'Active Transport Construction': {
      'url':
          'https://data.austintexas.gov/api/views/hbh2-fkab/rows.csv?accessType=DOWNLOAD',
      'filename': 'transport_construction.csv',
      'directory': 'Austin/transport'
    },
    'Traffic Resignal Timing': {
      'url':
          'https://data.austintexas.gov/api/views/g8w2-8uap/rows.csv?accessType=DOWNLOAD',
      'filename': 'resignal_timing.csv',
      'directory': 'Austin/transport'
    },
    'Metro bike Kiosk Locations': {
      'url':
          'https://data.austintexas.gov/api/views/qd73-bsdg/rows.csv?accessType=DOWNLOAD',
      'filename': 'kiosk_location.csv',
      'directory': 'Austin/transport'
    },
    'Bid Book Spreadsheet': {
      'url':
          'https://data.texas.gov/api/views/qwhy-c2kk/rows.csv?accessType=DOWNLOAD',
      'filename': 'bid_book_spreadsheet.csv',
      'directory': 'Austin/transport'
    },
    'Self Sufficiency wage': {
      'url':
          'https://data.austintexas.gov/api/views/jfwk-6vr6/rows.csv?accessType=DOWNLOAD',
      'filename': 'self_wage.csv',
      'directory': 'Austin/transport'
    },

    //Boulder Health
    'Human Relation Fund': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/761b818a0fef4776bea6b60ac3e82e6c_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'human_relation.csv',
      'directory': 'Boulder/health'
    },
    'Human Equity Fund': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/449cd507ab82477ba5350908e6db3c23_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'human_equity.csv',
      'directory': 'Boulder/health'
    },
    'Human Services Fund': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/61b1b61f809f4f18be492a26c13615ae_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'human_service.csv',
      'directory': 'Boulder/health'
    },
    'Parent Engagement Event': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/25eba477c3e248bdb1291538d0ccb277_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'parent_engagement.csv',
      'directory': 'Boulder/health'
    },
    'Community Organizations Fund': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/c7301d112010495eaab25861e88dcad1_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'community_org.csv',
      'directory': 'Boulder/health'
    },

    //Boulder Livable
    'Building Use and Square Footage': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/0937e0b5dbaf45fd8a3a1c7d5de7cdb4_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'building_use.csv',
      'directory': 'Boulder/livable'
    },
    'Homelessness program': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/1db2b02123d547c4bb5d7298ce981237_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'homelessness.csv',
      'directory': 'Boulder/livable'
    },
    'Community Assessment': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/7fb80cf7a352462a9dfe3f2110c2e8f4_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'comm_assessment.csv',
      'directory': 'Boulder/livable'
    },
    'Police Stops': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/1f850e90d27a4bf58d5b66405d59045f_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'police_stops.csv',
      'directory': 'Boulder/livable'
    },

    //Boulder Government
    'Boards Applicants': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/21de1042215a473683941473ce6dce1a_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'board_applicants.csv',
      'directory': 'Boulder/government'
    },
    'Account Payable': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/10c2e57f741b45428c492f67aeb98b1b_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'account_payable.csv',
      'directory': 'Boulder/government'
    },
    'Active Business Licenses': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/179de1dbf45a4205b69ad65edef29559_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'active_licenses.csv',
      'directory': 'Boulder/government'
    },
    'Licensed Contractors': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/ef02bbe733464632aa0d2628177d6c9e_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'licensed_contractors.csv',
      'directory': 'Boulder/government'
    },
    'Bicyclist and Pedestrians': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/56774397564548768bd5a209104b04b2_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'bicyclist_pedestrian.csv',
      'directory': 'Boulder/government'
    },
    'OSMP': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/de03870a382744d7900197a15c565dd5_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'osmp.csv',
      'directory': 'Boulder/government'
    },


    //Chicago Ethics
    'Registry': {
      'url':
          'https://data.cityofchicago.org/api/views/ypez-j3yg/rows.csv?accessType=DOWNLOAD',
      'filename': 'registry.csv',
      'directory': 'Chicago/ethics'
    },
    'Lobby Clients': {
      'url':
          'https://data.cityofchicago.org/api/views/g8p5-y4m5/rows.csv?accessType=DOWNLOAD',
      'filename': 'lobby_clients.csv',
      'directory': 'Chicago/ethics'
    },
    'Lobby lobbyist': {
      'url':
          'https://data.cityofchicago.org/api/views/tq3e-t5yq/rows.csv?accessType=DOWNLOAD',
      'filename': 'lobby_lobbyist.csv',
      'directory': 'Chicago/ethics'
    },
    'Lobby contributors': {
      'url':
          'https://data.cityofchicago.org/api/views/p9p7-vfqc/rows.csv?accessType=DOWNLOAD',
      'filename': 'lobby_contributors.csv',
      'directory': 'Chicago/ethics'
    },
    'Lobby expenditure 1': {
      'url':
          'https://data.cityofchicago.org/api/views/bc2p-hky6/rows.csv?accessType=DOWNLOAD',
      'filename': 'lobby_expenditure1.csv',
      'directory': 'Chicago/ethics'
    },
    'Lobby expenditure 2': {
      'url':
          'https://data.cityofchicago.org/api/views/pvm2-bd2i/rows.csv?accessType=DOWNLOAD',
      'filename': 'lobby_expenditure2.csv',
      'directory': 'Chicago/ethics'
    },


    //Toronto Government
    'Polis Data': {
      'url':
          'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7bce9bf4-be5c-4261-af01-abfbc3510309/resource/13c405e8-f884-4950-baf8-07e0f7b0e299/download/Polls Data.csv',
      'filename': 'polis.csv',
      'directory': 'Toronto/government'
    },
    'Daily Shelter': {
      'url':
          'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/21c83b32-d5a8-4106-a54f-010dbe49f6f2/resource/ffd20867-6e3c-4074-8427-d63810edf231/download/Daily shelter overnight occupancy.csv',
      'filename': 'shelter.csv',
      'directory': 'Toronto/government'
    },
    'Apartment Evaluation': {
      'url':
          'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/4ef82789-e038-44ef-a478-a8f3590c3eb1/resource/979fb513-5186-41e9-bb23-7b5cc6b89915/download/Pre-2023 Apartment Building Evaluations.csv',
      'filename': 'apartment_evaluation.csv',
      'directory': 'Toronto/government'
    },
    'Apartment Registration': {
      'url':
          'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/2b98b3f3-4f3a-42a4-a4e9-b44d3026595a/resource/97b8b7a4-baca-49c7-915d-335322dbcf95/download/Apartment Building Registration Data.csv',
      'filename': 'apartment_registration.csv',
      'directory': 'Toronto/government'
    },
    'Measures': {
      'url':
          'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/0ff0cb64-9373-44d3-985c-f8d24bf270ab/resource/2846ef0d-dfce-4d7b-9673-491904220fc4/download/Measures 2020.csv',
      'filename': 'measures.csv',
      'directory': 'Toronto/government'
    },


    //Monterrey Data
    'EIRs': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/34f90cbd36aa4d3f80d18d06b8c4b188_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'eirs.csv',
      'directory': 'Monterrey/environment'
    },
    'Geology': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/8bbbb6b912ca41d790c1bc2dfc3920ad_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'geology.csv',
      'directory': 'Monterrey/environment'
    },
    'Mineral Resource Zones': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/0a1f9ac07785495298670cb2d6a598dd_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'resource.csv',
      'directory': 'Monterrey/environment'
    },
    'Erosion': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/79ba412ca2144f35a0a449785614f787_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'erosion.csv',
      'directory': 'Monterrey/environment'
    },
    'Liquefaction': {
      'url':
          'https://opendata.arcgis.com/api/v3/datasets/9dd4c3bb210140e286fcac742235257d_0/downloads/data?format=csv&spatialRefId=4326&where=1%3D1',
      'filename': 'liquefaction.csv',
      'directory': 'Monterrey/environment'
    },
  };

  static List<DownloadableKML> blankKml = [];

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

  static List<DownloadableKML> charlotteProductionKml = [
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/aeb1c5ada5a34ad79bed4d6baaa695de_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Environmental Justice 2020',
        size: '1.81 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/4bc6111bad6a4b9a8ca1755ba0c85ae5_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Access to Housing',
        size: '2.04 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/fea418953e5f43679bdb538335d6187c_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Access to Employment',
        size: '1.89 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/461483cbe560474799581a37adb76cda_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Access to Amenities',
        size: '1.80 MB'),
  ];

  static List<DownloadableKML> charlotteMiscKml = [
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/b8784a2b80c84170a13118ee64d90b03_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Adapted Microtransit Zones',
        size: '500.1 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/a1fbdd2f35aa46cba190e1e316e5907c_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Streets Map',
        size: '6.31 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/4be4e8ee21474cbb9225c0072c1f76b0_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Wifi Infrastructure',
        size: '63.3 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/5122be2b2c144dc892c83fff27f4f5be_13/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Officers Involved Shooting',
        size: '87.1 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/17a2c3919e48407699eb21bf7a948f9d_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Read Estate Easements',
        size: '87.1 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/cf66446f36244e2498aa9b3f8e704b84_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Water Quality Buffers',
        size: '81.9 MB'),
  ];

  static List<DownloadableKML> seattleTransportKml = [
    DownloadableKML(
        url:
            'https://data.seattle.gov/api/geospatial/qktt-2bsy?accessType=DOWNLOAD&method=export&format=KML',
        name: '2019 Paid Parking',
        size: '15 GB'),
    DownloadableKML(
        url:
            'https://data.seattle.gov/api/geospatial/6yaw-2m8q?accessType=DOWNLOAD&method=export&format=KML',
        name: '2018 Paid Parking',
        size: '15 GB'),
    DownloadableKML(
        url:
            'https://data.seattle.gov/api/geospatial/v4q3-5hvp?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Public Life Data',
        size: '1.89 MB'),
  ];

  static List<DownloadableKML> austinEnvironmentKml = [
    DownloadableKML(
        url:
            'https://data.texas.gov/api/geospatial/mwzi-gyw7?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Texas NOV',
        size: '10 GB+'),
    DownloadableKML(
        url:
            'https://data.texas.gov/api/geospatial/ups3-9e8m?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Counties Centroid',
        size: '142 KB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/5dcx-zjsm?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Spring CEF',
        size: '1.46 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/jxqt-k9f4?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Rock Outcrop',
        size: '1.56 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/erdi-rz7j?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Bio Resource Buffer',
        size: '8.9 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/uham-e4m2?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Grassland',
        size: '37.1 KB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/ugty-5b95?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Priority Tree',
        size: '2.4 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/isb7-5h5a?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Grow Zones',
        size: '311 KB'),
  ];

  static List<DownloadableKML> austinHealthKml = [
    DownloadableKML(
        url:
            'https://data.texas.gov/api/geospatial/gxdu-rsbb?accessType=DOWNLOAD&method=export&format=KML',
        name: 'CACFP 2018-19',
        size: '43.3 MB'),
    DownloadableKML(
        url:
            'https://data.texas.gov/api/geospatial/8rqi-6nkw?accessType=DOWNLOAD&method=export&format=KML',
        name: 'CACFP 2019-20',
        size: '53.4 MB'),
  ];

  static List<DownloadableKML> austinTransportKml = [
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/b4k4-adkb?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Traffic Cameras',
        size: '1.39 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/p53x-x73x?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Traffic & Pedestrian Signals',
        size: '3.18 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/hst3-hxcz?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Traffic Signal Work Orders',
        size: '71.6 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/ivss-na93?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Street Sign Work Orders',
        size: '34.5 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/btg5-ebcy?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Pole Attachments',
        size: '1.32 MB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/4r2j-b4rx?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Dynamic Message Signs',
        size: '20 KB'),
    DownloadableKML(
        url:
            'https://data.austintexas.gov/api/geospatial/qpuw-8eeb?accessType=DOWNLOAD&method=export&format=KML',
        name: 'Traffic Detectors',
        size: '5.23 MB'),
  ];

  static List<DownloadableKML> boulderLivableKml = [
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/0fb10d7ab5134840bbd260bcafc5eb95_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Boulder Stolen Bikes',
        size: '1.69 MB'),
  ];

  static List<DownloadableKML> torontoGovernmentKml = [
    DownloadableKML(
        url:
            'https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/8d8f4405-7b90-4264-8607-b27ab63b9359/resource/fc2d9f28-3758-465c-bb03-412a2b794417/download/library-branch-locations.kml',
        name: 'Library Locations',
        size: '40 KB'),
  ];

  static List<DownloadableKML> monterreyEnvironmentKml = [
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/0a1f9ac07785495298670cb2d6a598dd_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Mineral Resource Zones',
        size: '473 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/e1cf610ac767454199e2f1704519b4cd_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Faults',
        size: '2.11 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/79ba412ca2144f35a0a449785614f787_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Erosion',
        size: '31.1 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/c6cae0bc46b443f9a913463d2d8ec81b_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Forest Planning Areas',
        size: '436 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/8bbbb6b912ca41d790c1bc2dfc3920ad_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Geology',
        size: '41.8 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/34f90cbd36aa4d3f80d18d06b8c4b188_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Moco EIRs',
        size: '201 KB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/9dd4c3bb210140e286fcac742235257d_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Liquefaction',
        size: '12.7 MB'),
    DownloadableKML(
        url:
            'https://opendata.arcgis.com/api/v3/datasets/cb82c3b4de8f42418272980c0eb46800_0/downloads/data?format=kml&spatialRefId=4326&where=1%3D1',
        name: 'Paleontology',
        size: '12.7 MB'),
  ];
}
