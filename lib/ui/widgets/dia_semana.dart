// dia_semana.dart

import 'package:flutter/material.dart';
// Não precisa mais desta importação aqui: import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class DiaSemanaWidget extends StatelessWidget {
  const DiaSemanaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Agora isso vai funcionar sem erro, pois a inicialização foi feita no main.dart
    final agora = DateTime.now();
    final diaSemana = DateFormat.EEEE('pt_BR').format(agora);

    return Text(
      diaSemana, // ex: sexta-feira
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    );
  }
}