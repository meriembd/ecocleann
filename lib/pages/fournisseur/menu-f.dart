import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/bienvenu.dart';
import 'package:eco_clean/pages/fournisseur/accueil-f.dart';
import 'package:eco_clean/pages/fournisseur/apropos-f.dart';
import 'package:eco_clean/pages/fournisseur/calendrier-f.dart';
import 'package:eco_clean/pages/fournisseur/fournisseur-f.dart';
import 'package:eco_clean/pages/fournisseur/module_educatif-f.dart';
import 'package:eco_clean/pages/fournisseur/statistique-f.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 168, 189, 166),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Profil'),
            onTap: () async {
              final userSnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Fournisseur')
                  .limit(1)
                  .get();

              if (userSnapshot.docs.isNotEmpty) {
                final userData = userSnapshot.docs.first.data();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FournisseurProfile(
                      name: userData['fullName'],
                      address: userData['address'],
                      role: userData['role'],
                      phone: userData['phone'],
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Aucun utilisateur trouvé')),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.sign_language, color: Colors.black),
            title: Text('Déchets disponible'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccueilF()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.black),
            title: Text('Module éducatif'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ModuleEducatifsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.black),
            title: Text('Statistiques'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Statistique()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month, color: Colors.black),
            title: Text('Calendrier'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calendrier(userRole: 'fournisseur'),
                ),
              );
            },
          ),

          /*ListTile(
            leading: Icon(Icons.language, color: Colors.black),
            title: Text('Changer la langue'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Language()),
              );
            },
          ),*/
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('À propos d\'EcoClean'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Apropos()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text('Se déconnecter'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Bienvenue()),
              );
            },
          ),
        ],
      ),
    );
  }
}
