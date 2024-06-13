import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Client extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Fournisseurs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('fournisseurs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun fournisseur trouvé.'));
          }
          final fournisseurs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: fournisseurs.length,
            itemBuilder: (context, index) {
              final fournisseur = fournisseurs[index];
              return ListTile(
                title: Text(fournisseur['description'] ?? 'Sans description'),
                subtitle: Text('Quantité: ${fournisseur['quantite']}'),
                onTap: () {
                  _showFournisseurDetails(context, fournisseur);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showFournisseurDetails(
      BuildContext context, DocumentSnapshot fournisseur) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Détails du Fournisseur'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Quantité: ${fournisseur['quantite']}'),
                SizedBox(height: 8),
                Text('Description: ${fournisseur['description']}'),
                SizedBox(height: 8),
                Text('Location: ${fournisseur['location']}'),
                SizedBox(height: 8),
                Text('Photo: ${fournisseur['photo']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
