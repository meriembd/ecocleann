import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Listededechet extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Listededechet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mes Déchets'),
        ),
        body: const Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 90.0,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Mes déchets',
            style: TextStyle(
              fontSize: 39.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 36,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wasteForms')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun formulaire soumis'));
          }

          final formDocs = snapshot.data!.docs;

          return ListView.separated(
            itemCount: formDocs.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color.fromARGB(255, 18, 41, 19), //couleur des séparateurs
              thickness: 2, //epaisseur des séparateurs
            ),
            itemBuilder: (context, index) {
              final formDoc = formDocs[index];
              final formData = formDoc.data() as Map<String, dynamic>?;

              if (formData == null) {
                return const ListTile(
                  title: Text('Données invalides'),
                );
              }

              final fournisseur = Fournisseur(
                fullName: 'Moi',
                phone: 'N/A',
                adresse: 'N/A',
                email: 'N/A',
                type: formData['wasteType'] ?? 'N/A',
                quantite: formData['quantity'] ?? 'N/A',
                localisation: formData['location'] != null
                    ? '${(formData['location'] as GeoPoint).latitude}, ${(formData['location'] as GeoPoint).longitude}'
                    : 'N/A',
                description: formData['description'] ?? 'N/A',
                validated: formData['validated'] ?? false,
              );

              return ListTile(
                title: Text(fournisseur.type),
                subtitle: Text(
                    'Quantité: ${fournisseur.quantite}\nValidation: ${fournisseur.validated ? 'Validé' : 'En attente'}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(fournisseur.type),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDialogContent('Quantité', fournisseur.quantite),
                          _buildDialogContent(
                              'Localisation', fournisseur.localisation),
                          _buildDialogContent(
                              'Description', fournisseur.description),
                          _buildDialogContent('Validation',
                              fournisseur.validated ? 'Validé' : 'En attente'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Fermer',
                            style: TextStyle(
                              color: Color.fromARGB(255, 46, 61,
                                  46), // Changez la couleur en vert
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDialogContent(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: $value'),
        const SizedBox(height: 5),
      ],
    );
  }
}

class Fournisseur {
  final String fullName;
  final String phone;
  final String adresse;
  final String email;
  final String type;
  final String quantite;
  final String localisation;
  final String description;
  final bool validated;

  Fournisseur({
    required this.fullName,
    required this.phone,
    required this.adresse,
    required this.email,
    required this.type,
    required this.quantite,
    required this.localisation,
    required this.description,
    required this.validated,
  });
}
