import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:package_spectrum/spectrum_data.dart';
import 'package:spectrum_bar_chart/source/repository/amplifier/amplifier_repository.dart';
import 'package:spectrum_bar_chart/source/repository/amplifier/amplifier_repository_impl.dart';
import 'package:toastification/toastification.dart';

final getIt = GetIt.instance;

init(){
  getIt.registerSingleton<AmplifierRepository>(AmplifierRepositoryImpl());
}

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes:  {
          '/': (context) => const SpectrumDataChart(),
        },
        builder: (context, child) {
          return child!;
        },
      ),
    );
  }
}

