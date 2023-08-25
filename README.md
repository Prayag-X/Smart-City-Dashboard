<p align="center">
  <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/splash.png">
</p>  

<p align="center">
  <img alt="GitHub Repo stars" src="https://img.shields.io/badge/flutter-v3.7.6%20stable-blue?color=00092a&labelColor=blue">
  <img alt="GitHub Repo stars" src="https://img.shields.io/badge/dart-v2.19.3-blue?color=00092a&labelColor=blue">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/license/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=blue">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/repo-size/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=blue">
  </br>
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/watchers/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/forks/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/commit-activity/y/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/issues/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/issues-closed/Prayag-X/Smart-City-Dashboard?color=00092a&labelColor=001049">
</p>
</br>

# Smart City Dashboard
Android app to visualize many available public data of various Smart Cities through Dashboards. It will also connect with Liquid Galaxy to show the data in Google Earth in bigger screens for better visualization. The aim of the project is to make the open data of various Smart Cities easy to visualize and understand for everyone. The project hopes to create more awareness among the public regarding the data of their own city and eases the data analysis for general improvement of the city.

### Workflow:

<p align="center">
  <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/architechture.png">
</p>  

### Features:

- Works both with and without connecting to Liquid Galaxy.
- Visually appealing UI/UX with smooth animations.
- Dynamic Left Tab bar and 1 tap navigation for ease of use.
- Realtime weather data along with hourly and forecast data.
- Many categories of open data for each city like: Environemnt, Health, Transportation etc with `.kml` data as well to visualize in the Liquid Galaxy.
- Same interface as the app in the Liquid Galaxy
- Has the option to download and visaulize open data as well as delete those whenever required so that the app doesn't consume much storage.
- Integrated Google Map and many functions to control Liquid Galaxy.
- Visualizer for any custom `.csv` or `.kml` files.
- App tour to guide new users and highlight the features.
- 8+ Smart Cities data.
- 2 Themes (Dark/Light).
- 7 different languages.

# App Installation

### Prerequisites:
- Minimum 9-inch Tablet of resolution at least 2048 x 1536.
- Android SDK 24 or above (Codename: Android 7.0 or Nougat)
- Free Space of minimum 240 MB is required. Suggested Free Space is at least 500 MB (Including all in-app downloadable content).

### Download Sources:

<p align="center">
  <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/qr.png" width="200" height="200">
</p>  

- Scan the QR Code or download from the [Play Store link](https://play.google.com/store/apps/details?id=com.liquidgalaxy.smart_city_dashboard&hl=en-IN).
- Alternatively you can also download the apk from [this link](https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/releases/Smart%20City%20Dashboard%20-%201.1.0%20-%2024.08.2023.apk).
- If this alternate link doesn't work then manually download the apk in [this folder](https://github.com/Prayag-X/Smart-City-Dashboard/tree/main/releases). 

After the installation, you will get a tour when you open the app for the first time, providing guidance to how to use the app and highlighting all the important features. In case of any trouble, always check out the Help Page. Enjoy :D
</br>

# Integration with Liquid Galaxy:

Follow the instructions given [here](https://github.com/LiquidGalaxyLAB/liquid-galaxy#readme) to install and setup Liquid Galaxy in either multi-device rigs or virtual machines. For virtual machine setup follow  this [video](https://www.youtube.com/watch?v=CLdUuDHo6lU) or this [document](https://drive.google.com/file/d/1uwWEKms1ZHZoRjn4IKOchk71solLxpuL/view).
</br>
</br>
After this, go to the app Settings Page and under `Connection and Settings` fillup the required details and click on `CONNECT TO LG` and all done.

# App Screenshots

| | | |
| ------------- | ------------- | -------------- |
| <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/1.png"> | <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/3.png"> | <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/2.png"> |
| <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/8.png"> | <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/4.png"> | <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/readme_assets/screenshots/5.png"> |

# Setting up locally

### Prerequisites:

- Git
- Flutter SDK `v3.7.6 stable`
- Dart `v2.19.3`
- Android Studio or Visual Studio Code
- Minimum 9-inch Tablet of resolution at least 2048 x 1536 (Emulator or Real Device)

### Setting up required Flutter and Dart version:

Before starting, make sure the Flutter and Dart SDK are of the mentioned version to make sure there is no version error or mismatching while running the project. If your Flutter SDK doesn't match the given, use the following steps:
- Go to the folder where you installed Flutter (For example: C:/flutter/)
- Open terminal and execute these commands
  ```bash
  $ git checkout 3.7.6
  ```
  then
  ```dart
  $ flutter doctor
  ```
- Wait for the process to finish and your environment is ready to run the project!

### Clonning the Project:

```bash
$ git clone https://github.com/Prayag-X/Smart-City-Dashboard.git
$ cd Smart-City-Dashboard
```

### Preparing the API Keys (Optional):

There are 2 APIs that have been used in this project. The API Keys I have used are already given and not hidden to make the process of setting up the project easy. But its suggested to use your own keys if you are planning to work around the project for a longer time. (Please consider my API's daily limit as well and dont misuse it :) )

1. **Google Maps API:** To get your own key, you will need to follow the steps mentioned in [this documentation](https://docs.google.com/document/d/1_LDcuFSzZKv-69FrT41hHyZoMb7db7m5fxwGSKZScaE/edit?usp=sharing). Then go to the project's `android/app/src/main/AndroidManifest.xml` and paste the API key you got in place of `REPLACE_THE_API_KEY_HERE`.
  ```xml
  <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="REPLACE_THE_API_KEY_HERE"/>
  ```

2. **Weather API:** Go to [this link](https://rapidapi.com/weatherapi/api/weatherapi-com) then sign up if you don't have any account. Then subsribe to the FREE Basic plan of the API. Then select your project or keep it default. And `X-RapidAPI-Key` will be your key. Then go to the project's `lib/services/weather_api.dart` and replace line 6's `REPLACE_THE_API_KEY_HERE`:
  ```dart
  final String apiKey = 'REPLACE_THE_API_KEY_HERE';
  ```

### Running the Project:

First install all the Flutter packages
```dart
$ flutter pub get
```

Then connect a tablet (emulator/device) of the mentioned requirements and run
```dart
$ flutter run
```

# Open Source Contributions

It will be very appreciated if you want to contribute to this project. There are few ways you can contribute to this project:
- Add up more city data.
- Increase the data of each cities.
- Add more languages.
- Improve the overall stability of the app.
- Look up for possible bugs and try to fix it.
- Any imrprovement to the existing UI/UX.

Always feel free to open up any issues in the [Issues](https://github.com/Prayag-X/Smart-City-Dashboard/issues?q=is%3Aopen+is%3Aissue) section in case of any doubt or bug. I will be more than happy to help you out in every way possible. You can improve anything of the above mentioned things or work something on your own and make a Pull Request. I will review it asap. Happy Contributing :D

# Credits

The project was successfully made thanks to my mentor of *Google Summer of Code 2023* **Merul Dhiman** and Liquid Galaxy administrator **Andreu Ibáñez** who guided me in every way possible. Also thanks to **Alejandro Illan Marcos** for publishing the app in the Play Store and **Victor Carreras** for any Flutter related queries. The project wouldn't be completed without the support of **Mohamed Zazou**, **Navdeep Singh** and **Imad Laichi** who tested the app relentlessly for any possible bugs and improvements.

# License

This project is licensed under the [MIT license](https://opensource.org/licenses/MIT).
Copyright @ 2023 [Prayag Biswas](https://www.linkedin.com/in/prayag-biswas-293644215/)
