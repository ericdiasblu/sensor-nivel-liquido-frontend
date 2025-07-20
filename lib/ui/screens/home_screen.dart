import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(
    MaterialApp(
      home: CarDashboard(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    ),
  );
}

class CarDashboard extends StatefulWidget {
  @override
  _CarDashboardState createState() => _CarDashboardState();
}

class _CarDashboardState extends State<CarDashboard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _dataTimer;
  Timer? _simulationTimer;
  Timer? _batteryTimer;
  final Battery _battery = Battery();

  // Valores iniciais para demonstração
  double speed = 60.0; // Velocidade inicial mais realista
  double temperature = 75.0; // Temperatura inicial ideal
  double batteryLevel = 85; // Será atualizado com bateria real
  double fluidLevel = 60;

  // Alerta de fluido baixo
  bool isLowFluidAlert = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Start fetching data from API
    _fetchFluidLevel();
    _dataTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchFluidLevel();
    });

    // Timer para simular o comportamento realista do sistema
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      _updateSystemBehavior();
    });

    // Timer para atualizar bateria real do dispositivo
    _getBatteryLevel();
    _batteryTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _getBatteryLevel();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dataTimer?.cancel();
    _simulationTimer?.cancel();
    _batteryTimer?.cancel();
    super.dispose();
  }

  // Função para buscar o nível do fluido da API
  Future<void> _fetchFluidLevel() async {
    try {
      final response = await http
          .get(
            Uri.parse('http://192.168.0.17:5000/percentage'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assumindo que a API retorna um JSON com o campo 'percentage'
        // Se a API retornar apenas um número, use: double.parse(response.body)
        final percentage = data['percentage']?.toDouble() ?? data.toDouble();

        setState(() {
          fluidLevel = percentage.clamp(0.0, 100.0);
          // Verificar se deve ativar alerta de fluido baixo
          isLowFluidAlert = fluidLevel < 20.0;
        });
      } else {
        print('Erro ao buscar dados da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de conexão: $e');
      // Manter o último valor conhecido em caso de erro
    }
  }

  // Função para obter nível da bateria real do dispositivo
  Future<void> _getBatteryLevel() async {
    try {
      final batteryPercent = await _battery.batteryLevel;
      setState(() {
        batteryLevel = batteryPercent.toDouble();
      });
    } catch (e) {
      print('Erro ao obter nível da bateria: $e');
    }
  }

  // Lógica de comportamento realista do sistema
  void _updateSystemBehavior() {
    setState(() {
      // 1. Simular variação natural da velocidade (0-200 km/h)
      _simulateRealisticSpeed();

      // 2. Calcular temperatura baseada na velocidade e fluido (70-120°C)
      _calculateRealisticTemperature();

      // 3. Aplicar modo de segurança se temperatura crítica
      _applySafetyMode();
    });
  }

  void _simulateRealisticSpeed() {
    // Simula variação natural de velocidade
    final random = math.Random();
    final speedChange = (random.nextDouble() - 0.5) * 1.0; // Variação menor
    speed = (speed + speedChange).clamp(0.0, 200.0);
  }

  void _calculateRealisticTemperature() {
    // Temperatura base: 70°C (mínimo ideal)
    double baseTemp = 70.0;

    // Efeito da velocidade na temperatura
    double speedEffect = (speed / 200.0) * 30.0; // 0-30°C baseado na velocidade

    // Efeito do nível de fluido na temperatura
    double fluidEffect = 0.0;
    if (fluidLevel < 100.0) {
      // Menos fluido = mais temperatura
      fluidEffect = (100.0 - fluidLevel) / 100.0 * 20.0; // Até 20°C extra
    }

    // Temperatura alvo
    double targetTemp = baseTemp + speedEffect + fluidEffect;
    targetTemp = targetTemp.clamp(70.0, 120.0);

    // Mudança gradual da temperatura (inércia térmica)
    double tempDifference = targetTemp - temperature;
    temperature += tempDifference * 0.01; // Mudança muito gradual

    temperature = temperature.clamp(70.0, 120.0);
  }

  void _applySafetyMode() {
    // Se temperatura acima de 110°C, reduzir velocidade gradualmente
    if (temperature >= 110.0) {
      double maxSafeSpeed = 60.0; // Velocidade máxima segura
      if (speed > maxSafeSpeed) {
        speed = math.max(speed - 1.0, maxSafeSpeed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              // Alerta de fluido baixo
              if (isLowFluidAlert) _buildLowFluidAlert(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Velocímetro (esquerda)
                      Expanded(child: _buildSpeedometer()),
                      // Display central
                      _buildCentralDisplay(),
                      // Termostato (direita)
                      Expanded(child: _buildThermometer()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusIndicator('ENGINE', true),
          _buildStatusIndicator('AUTOPILOT', false),
        ],
      ),
    );
  }

  Widget _buildSpeedometer() {
    // Usamos TweenAnimationBuilder para animar a mudança de valor suavemente
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: speed),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, animatedSpeed, child) {
        return CustomPaint(
          painter: AnalogGaugePainter(
            value: animatedSpeed,
            maxValue: 200, // Alterado para 0-200 km/h
            unitLabel: 'km/h',
            needleColor: const Color(0xFF00D4FF),
            startAngle: 140, // Ângulo inicial em graus
            sweepAngle: 260, // Extensão total do medidor em graus
            divisions: 10, // 10 divisões (20 km/h cada)
            subdivisions: 4, // 4 subdivisões (5 km/h cada)
          ),
          // O child do CustomPaint é desenhado no centro
          child: child,
        );
      },
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'SPEED',
              style: TextStyle(
                color: Color(0xFF00D4FF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40), // Espaço para o ponteiro não cobrir o texto
          ],
        ),
      ),
    );
  }

  Widget _buildThermometer() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: temperature),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, animatedTemp, child) {
        // Interpola a cor do ponteiro baseado na nova faixa de temperatura (70-120°C)
        final tempColor =
            Color.lerp(
              Colors.cyan,
              Colors.red,
              ((animatedTemp - 70) / 50).clamp(
                0.0,
                1.0,
              ), // Ajustado para 70-120°C
            )!;

        return CustomPaint(
          painter: AnalogGaugePainter(
            value: animatedTemp,
            maxValue: 120, // Alterado para 70-120°C
            unitLabel: '°C',
            needleColor: tempColor,
            startAngle: 140,
            sweepAngle: 260,
            divisions: 10, // 10 divisões (5°C cada)
            subdivisions: 5,
          ),
          child: child,
        );
      },
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'TEMP',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralDisplay() {
    return Container(
      width: 130, // Largura ajustada
      height: 255, // Altura ajustada
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D4FF), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCentralInfo(
            'BATTERY',
            '${batteryLevel.toInt()}%',
            Icons.battery_charging_full,
          ),
          const Divider(
            color: Color(0xFF333333),
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          _buildCentralInfo('FLUID', '${fluidLevel.toInt()}%', Icons.opacity),
          /*const Divider(color: Color(0xFF333333), thickness: 1, indent: 10, endIndent: 10),
          _buildCentralInfo('RANGE', '420 km', Icons.route),*/
        ],
      ),
    );
  }

  Widget _buildCentralInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00D4FF), size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF888888), fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLowFluidAlert() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8 * _pulseController.value + 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'LOW FLUID ALERT - BELOW 20%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(String label, bool isActive) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    isActive
                        ? const Color(0xFF00FF88)
                        : const Color(0xFF444444),
                shape: BoxShape.circle,
                boxShadow:
                    isActive
                        ? [
                          BoxShadow(
                            color: const Color(
                              0xFF00FF88,
                            ).withOpacity(0.7 * _pulseController.value),
                            blurRadius: 8,
                            spreadRadius: 3,
                          ),
                        ]
                        : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? const Color(0xFF00FF88)
                        : const Color(0xFF666666),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Um CustomPainter genérico para desenhar medidores analógicos com ponteiro.
class AnalogGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final String unitLabel;
  final Color needleColor;
  final double startAngle;
  final double sweepAngle;
  final int divisions;
  final int subdivisions;

  AnalogGaugePainter({
    required this.value,
    required this.maxValue,
    this.unitLabel = '',
    this.needleColor = Colors.red,
    this.startAngle = 135,
    this.sweepAngle = 270,
    this.divisions = 10,
    this.subdivisions = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    // Converte ângulos de graus para radianos
    final startRad = startAngle * math.pi / 180;
    final sweepRad = sweepAngle * math.pi / 180;

    // Desenha as marcas e os números
    _drawMarkings(canvas, center, radius, startRad, sweepRad);

    // Desenha o ponteiro
    _drawNeedle(canvas, center, radius, value, startRad, sweepRad);

    // Desenha o pino central
    _drawCenterPin(canvas, center);
  }

  void _drawMarkings(
    Canvas canvas,
    Offset center,
    double radius,
    double startRad,
    double sweepRad,
  ) {
    final paint = Paint()..strokeCap = StrokeCap.round;

    final totalTicks = divisions * subdivisions;
    for (int i = 0; i <= totalTicks; i++) {
      final angle = startRad + (i / totalTicks) * sweepRad;

      final isDivision = i % subdivisions == 0;
      final tickLength = isDivision ? 15.0 : 7.0;
      final strokeWidth = isDivision ? 2.5 : 1.5;

      final p1 = Offset(
        center.dx + (radius - tickLength) * math.cos(angle),
        center.dy + (radius - tickLength) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      paint
        ..color = isDivision ? Colors.white : Colors.grey[600]!
        ..strokeWidth = strokeWidth;

      canvas.drawLine(p1, p2, paint);

      // Desenha os números das divisões principais
      if (isDivision) {
        final textValue = (i / totalTicks * maxValue).toInt().toString();
        final textPainter = TextPainter(
          text: TextSpan(
            text: textValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final textAngle = angle;
        final textOffset = Offset(
          center.dx +
              (radius - tickLength - 15) * math.cos(textAngle) -
              textPainter.width / 2,
          center.dy +
              (radius - tickLength - 15) * math.sin(textAngle) -
              textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  void _drawNeedle(
    Canvas canvas,
    Offset center,
    double radius,
    double value,
    double startRad,
    double sweepRad,
  ) {
    final valueRatio = (value / maxValue).clamp(0.0, 1.0);
    final needleAngle = startRad + valueRatio * sweepRad;

    final needlePaint =
        Paint()
          ..color = needleColor
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // O Path define a forma do ponteiro
    final needlePath =
        Path()
          ..moveTo(0, -5) // Base do ponteiro
          ..lineTo(radius - 10, 0) // Ponta do ponteiro
          ..lineTo(0, 5) // Outro lado da base
          ..lineTo(-20, 0) // Cauda do ponteiro
          ..close();

    canvas.save();
    // Move a origem do canvas para o centro do medidor
    canvas.translate(center.dx, center.dy);
    // Gira o canvas para o ângulo correto
    canvas.rotate(needleAngle);

    // Desenha a sombra e depois o ponteiro
    canvas.drawPath(needlePath.shift(const Offset(2, 2)), shadowPaint);
    canvas.drawPath(needlePath, needlePaint);

    // Restaura o estado anterior do canvas (sem rotação e translação)
    canvas.restore();
  }

  void _drawCenterPin(Canvas canvas, Offset center) {
    // Círculo central (pino do ponteiro)
    canvas.drawCircle(center, 12, Paint()..color = const Color(0xFF333333));
    canvas.drawCircle(center, 8, Paint()..color = needleColor.withOpacity(0.8));
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repinta apenas se o valor mudar para otimizar o desempenho
    return (oldDelegate as AnalogGaugePainter).value != value;
  }
}
