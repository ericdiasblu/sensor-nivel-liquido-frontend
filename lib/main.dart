import 'package:feduca_app/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Define apenas a orientação horizontal (landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MaterialApp(home: HomeScreen(),debugShowCheckedModeBanner: false,));
}