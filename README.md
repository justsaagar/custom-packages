# package_spectrum

A new Flutter project.

# Flutter Sdk version: 3.24.5

# Creating Package :-
1. create package Command :-
    - flutter create --template=package your_depedency_name

2. how to use this package :-
    - after cupertino_icons line added in pubspec.yaml
      `cupertino_icons: ^1.0.8
       spectrum_bar_chart :
            path: spectrum_bar_chart`

3. how to Use THis package in your project :-
    - import 'package:spectrum_bar_chart/spectrum_bar_chart.dart';
      - SpectrumBarChart(
        dataPoints: dsSpectrumDataPoints,
        dependencies: dependencies,
        ),

4. dsSpectrumDataPoints in Your Api Data :-
5. dependencies in Your Chart Ui Data :-

# Note :-
- Package in Toast use So your Project pubspec.yaml in add This package
  - https://pub.dev/packages/toastification
  - Version :- toastification: ^2.3.0
  - and import 'package:toastification/toastification.dart';
  - wrap toastification dependency put your main.dart File in wrap with ToastificationWrapper on GetMaterialApp.

  
# Run Steps :- 
- flutter pub get
- Connect With VPN
- flutter run
- after project Run open Console
- Click On Api Url on and press on advanced on and give access proceed.
- refresh screen and show spectrum data in chart.




