import 'package:flutter/material.dart';

class Ewaste extends StatelessWidget {
  const Ewaste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50.0),
          Center(
            child: Text(
              'E-waste',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 20, 29, 11),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ewaste.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(height: 19.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(29, 40, 29, 40),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 211, 130),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: const Text(
                        'Exemples:\nTéléphones portables, Ordinateur portables, Chargeurs et cables, Carte mémoires, Ecrans d\'ordinateur, Batteries, Télévieur, Imprimantes, Appareils photo numériques, Lecteurs DVD et CD, Tablettes, Claviers et souris...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 21.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
