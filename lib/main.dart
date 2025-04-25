import 'package:flutter/material.dart';
import 'package:package_spectrum/spectrum_data.dart';
import 'package:toastification/toastification.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Custom Spectrum Data Chart',
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

