import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/collecteur/menu-c.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ListeFournisseur extends StatelessWidget {
  final String selectedWasteType;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ListeFournisseur({Key? key, required this.selectedWasteType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuC(),
      backgroundColor: Color.fromARGB(255, 236, 236, 232),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 147, 172, 145),
        toolbarHeight: 79.0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Liste de fournisseur',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wasteForms')
            .where('wasteType', isEqualTo: selectedWasteType)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
                    'Aucun fournisseur pour le type de déchet sélectionné'));
          }

          final formDocs = snapshot.data!.docs;

          return ListView.separated(
            itemCount: formDocs.length,
            separatorBuilder: (context, index) => Divider(
              color: Color.fromARGB(255, 18, 41, 19), //couleur des séparateurs
              thickness: 2, //epaisseur des séparateurs
            ),
            itemBuilder: (context, index) {
              final formDoc = formDocs[index];
              final formData =
                  formDoc.data() as Map<String, dynamic>?; // Safe cast
              final userId = formData?['userId'] as String?;

              if (formData == null || userId == null) {
                print('Form data or user ID is null');
                return ListTile(
                  title: Text('Données invalides'),
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Chargement...'),
                    );
                  }

                  final userData =
                      userSnapshot.data?.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    print('User data is null for userId: $userId');
                    return ListTile(
                      title: Text('Données utilisateur invalides'),
                    );
                  }

                  final fournisseur = Fournisseur(
                    fullName: userData['fullName'] ?? 'Nom inconnu',
                    phone: userData['phone'] ?? 'N/A',
                    adresse: userData['adresse'] ?? 'N/A',
                    email: userData['email'] ?? 'N/A',
                    type: formData['wasteType'] ?? 'N/A',
                    quantite: formData['quantity'] ?? 'N/A',
                    localisation: formData['location'] != null
                        ? '${(formData['location'] as GeoPoint).latitude}, ${(formData['location'] as GeoPoint).longitude}'
                        : 'N/A',
                    description: formData['description'] ?? 'N/A',
                    validated: formData['validated'] ?? false,
                  );

                  return ListTile(
                    title: Text(fournisseur.fullName),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(fournisseur.fullName),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  launch("tel://${fournisseur.phone}");
                                },
                                child: _buildDialogContent(
                                    'Phone', fournisseur.phone),
                              ),
                              _buildDialogContent(
                                  'Adresse', fournisseur.adresse),
                              _buildDialogContent('Email', fournisseur.email),
                              _buildDialogContent('Type', fournisseur.type),
                              _buildDialogContent(
                                  'Quantité', fournisseur.quantite),
                              _buildDialogContent(
                                  'Localisation', fournisseur.localisation),
                              _buildDialogContent(
                                  'Description', fournisseur.description),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Fermer',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 101, 129, 102),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context,
                                  'Valider',
                                  'Êtes-vous sûr de vouloir valider ce formulaire?',
                                  () async {
                                    await FirebaseFirestore.instance
                                        .collection('wasteForms')
                                        .doc(formDoc.id)
                                        .update({'validated': true});
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                              child: Text(
                                'Valider',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 101, 129, 102),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _showConfirmationDialog(
                                  context,
                                  'Déjà récupéré',
                                  'Êtes-vous sûr de vouloir supprimer ce formulaire?',
                                  () async {
                                    await FirebaseFirestore.instance
                                        .collection('wasteForms')
                                        .doc(formDoc.id)
                                        .delete();
                                    Navigator.of(context).pop();
                                    _showEvaluationDialog(context, userId);
                                  },
                                );
                              },
                              child: Text(
                                'Déjà récupéré',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 101, 129, 102),
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
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Non',
              style: TextStyle(
                color: Color.fromARGB(255, 101, 129, 102),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: Text(
              'Oui',
              style: TextStyle(
                color: Color.fromARGB(255, 101, 129, 102),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEvaluationDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Évaluation'),
        content: Evaluation(userId: userId),
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

class Evaluation extends StatefulWidget {
  final String userId;

  const Evaluation({super.key, required this.userId});

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  double rating = 0;

  void showInstruction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Instructions d\'évaluation'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text('5 points pour des déchets "bien triés"'),
              Text('3 points pour des déchets "partiellement triés"'),
              Text('1 point pour des déchets "non triés"'),
              Text('0 point pour des déchets avec des contaminations'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 19, color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Évaluation de l\'état du déchet: $rating',
          style: const TextStyle(fontSize: 23),
        ),
        const SizedBox(height: 35),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
          onPressed: showInstruction,
          child: const Text(
            'Instructions',
            style: TextStyle(fontSize: 29),
          ),
        ),
        const SizedBox(height: 20),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: const EdgeInsets.symmetric(horizontal: 5),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Color.fromARGB(255, 105, 153, 111),
          ),
          onRatingUpdate: (newRating) => setState(() {
            rating = newRating;
          }),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          ),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .update({'points': FieldValue.increment(rating.toInt())});
            Navigator.of(context).pop();
          },
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}
