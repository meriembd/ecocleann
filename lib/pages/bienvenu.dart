import 'package:eco_clean/pages/collecteur/inscrire1-c.dart';
import 'package:eco_clean/pages/collecteur/seconnecter-c.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:flutter/material.dart';

class Bienvenue extends StatelessWidget {
  const Bienvenue({super.key});

  @override
  Widget build(BuildContext context) {
    return partager(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 200.0),
        ),
        Center(
          child: Text(
            'Bienvenue!',
            style:
                TextStyle(fontSize: 49, color: Color.fromARGB(255, 9, 126, 34)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Inscrire1()));
          },
          child: Container(
            height: 53,
            width: 320,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 3, 68, 17),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color.fromARGB(255, 15, 151, 45)),
            ),
            child: const Center(
              child: Text(
                'S\'inscrire',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SeConnecter()));
          },
          child: Container(
            height: 53,
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            child: const Center(
              child: Text(
                'Se connecter',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 68, 17)),
              ),
            ),
          ),
        ),
        const Spacer(),
      ]),
    );
  }
}
