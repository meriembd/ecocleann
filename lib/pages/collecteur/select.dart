import 'package:eco_clean/pages/collecteur/listefournisseur.dart';
import 'package:eco_clean/pages/collecteur/menu-c.dart';
import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  const Select({super.key});

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? _selectedWasteType;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuC(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 79.0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Gestion de dechets',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Veuillez choisir le type de déchet voulu',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Sélectionner un type de déchet'),
              value: _selectedWasteType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWasteType = newValue;
                });
              },
              items: <String>[
                'E-waste',
                'Plastique',
                'Papier',
                'Textile',
                'Verre',
                'Organique',
                'Metal'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 223, 223, 200),
                foregroundColor: Color.fromARGB(255, 94, 119, 94),
              ),
              onPressed: _selectedWasteType == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListeFournisseur(
                            selectedWasteType: _selectedWasteType!,
                          ),
                        ),
                      );
                    },
              child: const Text('Envoyer'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
