import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CursosPeruApp());
}

class CursosPeruApp extends StatelessWidget {
  const CursosPeruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cursos Perú Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC61A09)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOnline = true;
  String selectedFilter = 'Todos';

  // Base de datos de cursos de alto valor para CV en Perú
  final List<Map<String, dynamic>> cursos = [
    {
      'titulo': 'Capacitación Laboral y Habilidades Digitales',
      'entidad': 'MTPE (Empleos Perú)',
      'tipo': 'Estado',
      'costo': 'Gratis con Certificado',
      'destacado': true,
      'url': 'https://www.empleosperu.gob.pe/capacitacion-laboral/',
    },
    {
      'titulo': 'Curso de Extensión Universitaria (CEU) en Regulación',
      'entidad': 'OSINERGMIN / OSIPTEL',
      'tipo': 'CEU Estado',
      'costo': 'Beca Completa / Gratis',
      'destacado': true,
      'url': 'https://www.gob.pe/osinergmin',
    },
    {
      'titulo': 'Telecomunicaciones, Redes y Fibra Óptica',
      'entidad': 'INICTEL-UNI',
      'tipo': 'Universidad',
      'costo': 'Gratis / Oferta',
      'destacado': true,
      'url': 'https://www.inictel-uni.edu.pe/',
    },
    {
      'titulo': 'Cursos Abiertos y Especializaciones PUCP',
      'entidad': 'OpenPUCP / Coursera',
      'tipo': 'Universidad',
      'costo': 'Gratis (Auditable) / Pagado',
      'destacado': false,
      'url': 'https://open.pucp.edu.pe/',
    },
    {
      'titulo': 'Programas de Capacitación Continua San Marcos',
      'entidad': 'UNMSM (CERSEU)',
      'tipo': 'Universidad',
      'costo': 'Costo Social / Ofertas',
      'destacado': false,
      'url': 'https://unmsm.edu.pe/',
    },
    {
      'titulo': 'Propiedad Intelectual y Patentes para Emprendedores',
      'entidad': 'INDECOPI',
      'tipo': 'Estado',
      'costo': 'Gratis con Certificado',
      'destacado': false,
      'url': 'https://www.gob.pe/indecopi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
      if (isOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Conectado! Buscando cursos y convocatorias actualizadas...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });
  }

  Future<void> _abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursosFiltrados = selectedFilter == 'Todos'
        ? cursos
        : cursos.where((c) => c['tipo'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos y Becas Perú', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFFC61A09),
      ),
      body: Column(
        children: [
          // Banner indicador de Conexión
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: isOnline ? Colors.green.shade700 : Colors.orange.shade800,
            child: Row(
              children: [
                Icon(isOnline ? Icons.wifi : Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isOnline 
                      ? 'Conectado a Internet - Cursos verificados para tu CV'
                      : 'Sin conexión a internet. Mostrando cursos guardados.',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['Todos', 'Estado', 'CEU Estado', 'Universidad'].map((filtro) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filtro),
                    selected: selectedFilter == filtro,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filtro;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Lista de Cursos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cursosFiltrados.length,
              itemBuilder: (context, index) {
                final curso = cursosFiltrados[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                curso['entidad'],
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 12),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: curso['costo'].contains('Gratis') ? Colors.green.shade50 : Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                curso['costo'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: curso['costo'].contains('Gratis') ? Colors.green.shade900 : Colors.brown.shade800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          curso['titulo'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC61A09),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('Postular / Ver Curso Oficial'),
                            onPressed: () => _abrirEnlace(curso['url']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
