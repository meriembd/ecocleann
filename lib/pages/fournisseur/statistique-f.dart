import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:eco_clean/statistique/bar_graph.dart';
import 'package:flutter/material.dart';

class Statistique extends StatefulWidget {
  const Statistique({super.key});

  @override
  State<Statistique> createState() => _StatistiqueState();
}

class _StatistiqueState extends State<Statistique> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Liste des donnees
  List<double> weeklySummary = [
    4.40,
    2.50,
    42.42,
    10.50,
    100.20,
    88.99,
    90.10,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      backgroundColor: Color.fromARGB(255, 255, 252, 252),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 59.0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Statistique',
            style: TextStyle(
              fontSize: 39.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 36,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Impact du recyclage dans la communauté',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Les données ci-dessous montrent la quantité de matériaux recyclés chaque jour de la semaine passée.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 345,
                child: MyBarGraph(
                  weeklySummary: weeklySummary,
                ),
              ),
              const SizedBox(height: 23),
              const Text(
                'Continuons à recycler pour un avenir meilleur!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
