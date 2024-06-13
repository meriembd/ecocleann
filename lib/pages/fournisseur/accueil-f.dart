import 'package:eco_clean/pages/fournisseur/choixdedechets-f.dart';
import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:flutter/material.dart';

class AccueilF extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); //la gestion du Drawer

  AccueilF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, //gestion du Drawer
      drawer: Menu(),
      body: Stack(
        children: [
          partager(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoixDeDechets(),
                  ),
                );
              },
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top:
                              79.0), //ajuster la valeur pour déplacer l'image vers le bas
                      child: SizedBox(
                        height: 455,
                        width: 455,
                        child: Image.asset(
                          'assets/images/poubelle.png',
                          // ajuster l'image pour couvrir la taille spécifiée
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 5,
            child: IconButton(
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
        ],
      ),
    );
  }
}
