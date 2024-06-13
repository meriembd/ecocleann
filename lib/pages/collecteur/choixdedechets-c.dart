import 'package:eco_clean/pages/collecteur/menu-c.dart';
import 'package:eco_clean/pages/collecteur/select.dart';
import 'package:eco_clean/pages/fournisseur/dangereux-f.dart';
import 'package:eco_clean/pages/fournisseur/ewaste-f.dart';
import 'package:eco_clean/pages/fournisseur/metal-f.dart';
import 'package:eco_clean/pages/fournisseur/organique-f.dart';
import 'package:eco_clean/pages/fournisseur/papier-f.dart';
import 'package:eco_clean/pages/fournisseur/plastique-f.dart';
import 'package:eco_clean/pages/fournisseur/textile-f.dart';
import 'package:eco_clean/pages/fournisseur/verre-f.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:flutter/material.dart';

class ChoixDeDechets extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ChoixDeDechets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuC(),
      body: Stack(
        children: [
          partager(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Sélectionner le type de vos déchets',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGridItem(context, 'assets/images/ewaste.png',
                        'E-waste', Ewaste()),
                    _buildGridItem(context, 'assets/images/plastique.png',
                        'Plastique', Plastique()),
                    _buildGridItem(context, 'assets/images/papier.png',
                        'Papier', Papier()),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGridItem(context, 'assets/images/textiles.png',
                        'Textile', Textile()),
                    _buildGridItem(
                        context, 'assets/images/verre.png', 'Verre', Verre()),
                    _buildGridItem(context, 'assets/images/dangereux.png',
                        'Dangereux', Dangereux()),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGridItem(
                        context, 'assets/images/metal.png', 'Metal', Metal()),
                    _buildGridItem(context, 'assets/images/organique.png',
                        'Organique', Organique()),
                  ],
                ),
                SizedBox(height: 1.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Select(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 245, 238, 208),
                    ),
                    child: Text(
                      'Suivant',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
              ],
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

  Widget _buildGridItem(
      BuildContext context, String imagePath, String label, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 5.0),
          Text(
            label,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
