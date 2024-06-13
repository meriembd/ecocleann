import 'package:flutter/material.dart';

class Dangereux extends StatelessWidget {
  const Dangereux({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 241, 193),
      body: Column(
        children: [
          SizedBox(height: 50.0),
          Center(
            child: Text(
              'Dangereux ',
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
                    'assets/images/dangereux.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(41, 30, 41, 30),
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
                        'Exemples:\nPeintures, Solvants, Piles au lithim, Produits chimiques de nettoyage, Pesticides, Thermométres au mercure, Produits pharmaceutiques périmés, Déchets médicaux infeclieux, Gaz réfrigérants...',
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
