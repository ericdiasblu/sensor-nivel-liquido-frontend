// main.dart

import 'package:feduca_app/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicialize a formatação de data para o locale 'pt_BR' ANTES de rodar o app
  await initializeDateFormatting('pt_BR', null);

  // Define apenas a orientação horizontal (landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
      MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      )
  );
}