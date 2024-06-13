import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/fournisseur/accueil-f.dart';
import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Formulaire extends StatefulWidget {
  Formulaire({super.key});

  @override
  _FormulaireState createState() => _FormulaireState();
}

class _FormulaireState extends State<Formulaire> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _selectedWasteType;
  Position? _currentPosition;

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Les services de localisation sont désactivés.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Les permissions de localisation sont refusées')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Les permissions de localisation sont refusées en permanence.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez obtenir votre localisation')),
        );
        return;
      }

      final description = _descriptionController.text;
      final quantity = _quantityController.text;
      final wasteType = _selectedWasteType;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur non connecté')),
        );
        return;
      }
      final userId = user.uid;
      GeoPoint geoPoint =
          GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);

      try {
        await FirebaseFirestore.instance.collection('wasteForms').add({
          'description': description,
          'quantity': quantity,
          'wasteType': wasteType,
          'location': geoPoint,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccueilF(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors de l\'enregistrement du formulaire: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      body: Stack(
        children: [
          partager(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 50),
                              const Text(
                                'Remplir ce formulaire',
                                style: TextStyle(
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30.0),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Type de Déchet',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 230, 245, 218),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 153, 111),
                                        width: 2.0),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 46, 66, 48)),
                                ),
                                value: _selectedWasteType,
                                items: [
                                  'E-waste',
                                  'Plastique',
                                  'Papier',
                                  'Textile',
                                  'Verre',
                                  'Dangereux',
                                  'Organique',
                                  'Metal'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedWasteType = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner un type de déchet';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _quantityController,
                                decoration: const InputDecoration(
                                  labelText: 'Quantité de Déchet',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 230, 245, 218),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 153, 111),
                                        width: 2.0),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 46, 66, 48)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer une quantité de déchet';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () async {
                                  await _getCurrentLocation();
                                  if (_currentPosition != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Localisation obtenue')),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  color:
                                      const Color.fromARGB(255, 230, 245, 218),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on),
                                      const SizedBox(width: 10.0),
                                      Text(_currentPosition == null
                                          ? 'Localisation'
                                          : 'Localisation obtenue'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 230, 245, 218),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 153, 111)),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 46, 66, 48)),
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: _saveForm,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 164, 187, 146),
                                    ),
                                  ),
                                  child: const Text(
                                    'Envoyer',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 46, 66, 48)),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
