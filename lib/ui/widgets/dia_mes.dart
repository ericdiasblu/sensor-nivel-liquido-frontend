import 'package:flutter/material.dart';

class DiaDoMesWidget extends StatelessWidget {
  const DiaDoMesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final agora = DateTime.now();
    final diaDoMes = agora.day.toString().padLeft(2, '0'); // garante 2 dígitos

    return Text(
      diaDoMes, // ex: 04, 15, 18
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }
}
