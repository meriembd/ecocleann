import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/fournisseur/menu-f.dart';
import 'package:flutter/material.dart';

class FournisseurProfile extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String name;
  final String address;
  final String role;
  final String phone;

  FournisseurProfile({
    required this.name,
    required this.address,
    required this.role,
    required this.phone,
  });

  @override
  _FournisseurProfileState createState() => _FournisseurProfileState();
}

class _FournisseurProfileState extends State<FournisseurProfile> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late String _documentId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _addressController = TextEditingController(text: widget.address);
    _phoneController = TextEditingController(text: widget.phone);
    _fetchDocumentId();
  }

  Future<void> _fetchDocumentId() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isEqualTo: widget.name)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      setState(() {
        _documentId = userSnapshot.docs.first.id;
      });
    }
  }

  Future<int> _fetchPoints() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isEqualTo: widget.name)
        .get();

    if (userSnapshot.docs.isEmpty) {
      return 0;
    }

    final userData = userSnapshot.docs.first.data();
    return userData['points'] ?? 0;
  }

  Future<void> _updateUserInfo() async {
    if (_documentId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_documentId)
          .update({
        'fullName': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informations mises à jour avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de mise à jour des informations')),
      );
    }
  }

  Color getProgressColor(int points) {
    if (points <= 20) {
      return Colors.red;
    } else if (points <= 40) {
      return Colors.orange;
    } else if (points <= 60) {
      return Colors.yellow;
    } else if (points <= 80) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  double getProgressValue(int points) {
    return points / 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      drawer: Menu(),
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<int>(
              future: _fetchPoints(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Erreur de chargement des données.');
                }
                final points = snapshot.data ?? 0;

                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.95, //largeur du container
                  height: MediaQuery.of(context).size.height *
                      0.73, //hauteur du container
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 168, 189, 166),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 169, 180, 171)
                            .withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildEditableCard('Nom & Prénom', _nameController),
                      const SizedBox(height: 5),
                      _buildEditableCard('Téléphone', _phoneController),
                      const SizedBox(height: 5),
                      _buildEditableCard('Adresse', _addressController),
                      const SizedBox(height: 5),
                      _buildInfoCard('Choix de Rôle', widget.role),
                      const SizedBox(height: 5),
                      _buildProgressCard('Points', points),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _updateUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 215, 228, 207),
                  foregroundColor: const Color.fromARGB(255, 50, 80, 51),
                ),
                child: const Text('Sauvegarder les modifications'),
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 5,
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 36,
                color: Colors.black,
              ),
              onPressed: () {
                widget._scaffoldKey.currentState!.openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCard(String label, TextEditingController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String label, int points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: getProgressValue(points),
            color: getProgressColor(points),
            backgroundColor: Colors.grey[300],
            minHeight: 10,
          ),
          const SizedBox(height: 4),
          Text(
            '$points points',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
