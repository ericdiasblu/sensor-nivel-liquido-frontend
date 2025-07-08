import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    home: CarDashboard(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class CarDashboard extends StatefulWidget {
  @override
  _CarDashboardState createState() => _CarDashboardState();
}

class _CarDashboardState extends State<CarDashboard> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  // Valores iniciais para demonstração
  double speed = 180.0;
  double temperature = 90.0;
  double batteryLevel = 85;
  double fluidLevel = 60;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Funções para atualizar o estado (usado pelos Sliders de demo)
  void _updateState(Function() update) {
    setState(update);
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
          const Text(
            'TESLA MODEL S',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
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
            maxValue: 240,
            unitLabel: 'km/h',
            needleColor: const Color(0xFF00D4FF),
            startAngle: 140, // Ângulo inicial em graus
            sweepAngle: 260, // Extensão total do medidor em graus
            divisions: 12,
            subdivisions: 5,
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
        // Interpola a cor do ponteiro com base na temperatura
        final tempColor = Color.lerp(
            Colors.cyan, Colors.red, (animatedTemp / 200).clamp(0.0, 1.0))!;
            
        return CustomPaint(
          painter: AnalogGaugePainter(
            value: animatedTemp,
            maxValue: 200,
            unitLabel: '°C',
            needleColor: tempColor,
            startAngle: 140,
            sweepAngle: 260,
            divisions: 10,
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
              'BATTERY', '${batteryLevel.toInt()}%', Icons.battery_charging_full),
          const Divider(color: Color(0xFF333333), thickness: 1, indent: 10, endIndent: 10),
          _buildCentralInfo(
              'FLUID', '${fluidLevel.toInt()}%', Icons.opacity),
          const Divider(color: Color(0xFF333333), thickness: 1, indent: 10, endIndent: 10),
          _buildCentralInfo('RANGE', '420 km', Icons.route),
        ],
      ),
    );
  }

  Widget _buildCentralInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00D4FF), size: 24),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value,
            style:
                const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
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
                color: isActive ? const Color(0xFF00FF88) : const Color(0xFF444444),
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00FF88).withOpacity(0.7 * _pulseController.value),
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
                color: isActive ? const Color(0xFF00FF88) : const Color(0xFF666666),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildDemoSliders() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      color: Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const Text("Speed", style: TextStyle(color: Colors.white)),
            Expanded(child: Slider(value: speed, min: 0, max: 240, onChanged: (v) => _updateState(() => speed = v), activeColor: const Color(0xFF00D4FF))),
            Text(speed.toInt().toString(), style: const TextStyle(color: Color(0xFF00D4FF), fontWeight: FontWeight.bold)),
          ]),
          Row(children: [
            const Text("Temp ", style: TextStyle(color: Colors.white)),
            Expanded(child: Slider(value: temperature, min: 0, max: 200, onChanged: (v) => _updateState(() => temperature = v), activeColor: Colors.redAccent)),
            Text(temperature.toInt().toString(), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
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

  void _drawMarkings(Canvas canvas, Offset center, double radius, double startRad, double sweepRad) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round;

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
          text: TextSpan(text: textValue, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        final textAngle = angle;
        final textOffset = Offset(
          center.dx + (radius - tickLength - 15) * math.cos(textAngle) - textPainter.width / 2,
          center.dy + (radius - tickLength - 15) * math.sin(textAngle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius, double value, double startRad, double sweepRad) {
    final valueRatio = (value / maxValue).clamp(0.0, 1.0);
    final needleAngle = startRad + valueRatio * sweepRad;
    
    final needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;
      
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
    // O Path define a forma do ponteiro
    final needlePath = Path()
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
  
  void _drawCenterPin(Canvas canvas, Offset center){
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