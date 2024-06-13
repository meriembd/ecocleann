import 'package:eco_clean/pages/collecteur/inscrire2-c.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:flutter/material.dart';

class Inscrire1 extends StatefulWidget {
  const Inscrire1({super.key});

  @override
  State<Inscrire1> createState() => _SignUpState();
}

class _SignUpState extends State<Inscrire1> {
  final _fromSignUpKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _adresse = TextEditingController();
  bool agreePersonalData = true;
  String? _selectedRole;
  List<String> roles = ['Fournisseur', 'Collecteur'];

  @override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _adresse.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return partager(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 99,
            child: Container(
              padding: const EdgeInsets.fromLTRB(19, 59, 19, 59),
              child: SingleChildScrollView(
                child: Form(
                  key: _fromSignUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Inscrivez-vous !',
                        style: TextStyle(
                          fontSize: 39,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 65, 105, 61),
                        ),
                      ),
                      SizedBox(height: 29),
                      //nom complet
                      TextFormField(
                        controller: _fullName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'entrer votre nom complet!';
                          } else if (value.length < 6) {
                            return 'le nom doit avoir au moin 6 caracteres';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('nom & prenom'),
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'entrer votre nom complet',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 19),
                      //numero de tel
                      TextFormField(
                        controller: _phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrez votre numéro de téléphone!';
                          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Entrez un numéro de téléphone valide!';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: const Text('Numéro de téléphone'),
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'Entrez votre numéro de téléphone',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 19),
                      //adresse
                      TextFormField(
                        controller: _adresse,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre adresse complète!';
                          }

                          //separe l'adresse en ses différents composants
                          List<String> addressComponents = value.split(' ');

                          //verifie s'il y a au moins 3 composants (numéro, rue, wilaya)
                          if (addressComponents.length < 3) {
                            return 'Adresse incomplète!';
                          }

                          //valide le premier composant(le numéro de maison)
                          if (addressComponents[0].trim().isEmpty) {
                            return 'Entrez le numéro de votre maison!';
                          }

                          //valide le deuxième composant(valide la rue)
                          if (addressComponents[1].trim().isEmpty) {
                            return 'Entrez le nom de votre rue!';
                          }

                          // le dernier composant(valide la wilaya)
                          if (addressComponents.last.trim().isEmpty) {
                            return 'Entrez le nom de votre wilaya!';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Adresse',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'Numéro Rue Wilaya',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 19),
                      //choix de role
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez choisir un rôle';
                          }
                          return null;
                        },
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          label: const Text('Choix de rôle'),
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'Choisissez un rôle',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 78, 148, 78),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 29),
                      ElevatedButton(
                        onPressed: () {
                          //naviguer vers la page suivante
                          if (_fromSignUpKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Inscrire2(
                                  fullName: _fullName.text,
                                  phone: _phone.text,
                                  adresse: _adresse.text,
                                  role: _selectedRole!,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Suivant',
                          style: TextStyle(
                            fontSize: 31,
                            color: Color.fromARGB(255, 6, 59, 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
