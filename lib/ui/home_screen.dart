import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Colors.black, Colors.grey[900]!, Colors.black],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 600,
                    height: 600,
                    child: Image.asset(
                      'assets/fuel-image.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 340,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey[800]!, width: 5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha superior - Horário e indicadores
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, // Faz o texto ocupar toda a largura
                        children: [
                          Text(
                            "NW 10:18 P",
                            textAlign: TextAlign.center, // Centraliza o texto horizontalmente
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(
                            height: 8, // Espaço entre o texto e a linha
                          ),
                          Divider(
                            color: const Color.fromARGB(255, 255, 255, 255), // Cor da linha
                            thickness: 2, // Espessura da linha
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Indicador de sinal
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Primeira barra (mais baixa)
                              Container(
                                width: 3,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                              SizedBox(width: 1),

                              // Segunda barra
                              Container(
                                width: 3,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                              SizedBox(width: 1),

                              // Terceira barra
                              Container(
                                width: 3,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                              SizedBox(width: 1),

                              // Quarta barra (mais alta)
                              Container(
                                width: 3,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "iPhone",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Ícones centrais
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ícone de bateria
                          Container(
                            width: 20,
                            height: 10,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 3, child: Container()),
                              ],
                            ),
                          ),

                          SizedBox(width: 20),

                          // Ícone de termômetro
                          Container(
                            width: 12,
                            height: 30,
                            child: Column(
                              children: [
                                Container(
                                  width: 8,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 20),

                          // Terceiro ícone
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ), // Espaço entre o texto e a linha
                      Divider(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ), // Cor da linha
                        thickness: 2, // Espessura da linha
                      ),
                      // Temperatura grande do radiador no centro
                      Center(
                        child: Text(
                          "60%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ), // Espaço entre o texto e a linha
                      Divider(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ), // Cor da linha
                        thickness: 2, // Espessura da linha
                      ),
                      // Linha inferior com informações
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Friday",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              Text(
                                "18",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "High",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              Text(
                                "10.1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 600,
                    height: 600,
                    child: Image.asset(
                      'assets/km-image.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
