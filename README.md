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

### Integration with Liquid Galaxy:

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
  ```bash
  $ flutter doctor
  ```
- Wait for the process to finish and your environment is ready to run the project!

### Running the Project:

First clone the repository
```bash
$ git clone https://github.com/Prayag-X/Smart-City-Dashboard.git
$ cd Smart-City-Dashboard
```
Now we have to install all the Flutter packages
```bash
$ flutter pub get
```
