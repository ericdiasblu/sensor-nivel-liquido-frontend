import 'package:flutter/material.dart';
import 'dart:async';

class TimerBr extends StatefulWidget {
  const TimerBr({super.key});

  @override
  State<TimerBr> createState() => _HoraBrasiliaWidgetState();
}

class _HoraBrasiliaWidgetState extends State<TimerBr> {
  late Timer _timer;
  String horaAtual = '';

  @override
  void initState() {
    super.initState();
    atualizarHora();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      atualizarHora();
    });
  }

  void atualizarHora() {
    final agora = DateTime.now();
    final horaFormatada = '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';
    setState(() {
      horaAtual = horaFormatada;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "NW $horaAtual P",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }
}
