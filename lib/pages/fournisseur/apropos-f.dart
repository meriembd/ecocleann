import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Apropos extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 172, 145),
        title: const Center(
          child: Text(
            'A propos d\'EcoClean',
            style: TextStyle(fontSize: 39.0),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EcoClean est une initiative née de l\'engagement de trois étudiantes en informatique à Mostaganem pour lutter contre la pollution et promouvoir le recyclage dans leur ville.\n\nMotivées par l\'ampleur du défi environnemental, elles ont développé une plateforme innovante pour faciliter la gestion des déchets et sensibiliser les citoyens. EcoClean encourage des pratiques responsables, augmente le taux de recyclage et promeut des comportements écologiques.\n\nRejoignez ce mouvement pour un avenir plus vert à Mostaganem!\n\n',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Contactez-nous sur: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'ecoclean2700@gmail.com',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 87, 150, 89),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Action à effectuer lorsque le texte est cliqué
                        // Par exemple, ouvrir une adresse e-mail
                        launch('mailto:ecoclean2700@gmail.com');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
