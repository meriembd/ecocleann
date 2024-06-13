import 'package:eco_clean/authentification/firebase_auth_services.dart';
import 'package:eco_clean/pages/collecteur/collecteur-c.dart';
import 'package:eco_clean/pages/collecteur/seconnecter-c.dart';
import 'package:eco_clean/pages/fournisseur/fournisseur-f.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Inscrire2 extends StatefulWidget {
  final String fullName;
  final String phone;
  final String adresse;
  final String role;

  const Inscrire2({
    super.key,
    required this.fullName,
    required this.phone,
    required this.adresse,
    required this.role,
  });

  @override
  State<Inscrire2> createState() => _inscrire2State();
}

class _inscrire2State extends State<Inscrire2> {
  final _fromSignUpKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool agreePersonalData = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _registerAndNavigate() async {
    if (_fromSignUpKey.currentState!.validate() && agreePersonalData) {
      User? user = await _authServices.signUpWithEmailAndPassword(
        _email.text,
        _password.text,
        widget.fullName,
        widget.phone,
        widget.adresse,
        widget.role,
      );

      if (user != null) {
        Map<String, dynamic>? userData =
            await _authServices.getUserData(user.uid);
        if (userData != null) {
          String userName = userData['fullName'];
          String userAddress = userData['adresse'];
          String userRole = userData['role'];
          String userPhone = userData['phone'];

          if (userRole == 'Collecteur') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CollecteurProfile(
                  name: userName,
                  address: userAddress,
                  role: userRole,
                  phone: userPhone,
                ),
              ),
            );
          } else if (userRole == 'Fournisseur') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FournisseurProfile(
                  name: userName,
                  address: userAddress,
                  role: userRole,
                  phone: userPhone,
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to retrieve user data. Please try again.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
          ),
        );
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les licences'),
        ),
      );
    }
  }

  void _showLicenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Licences'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '1-Objet de la Licence\n\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Cette licence vise à réglementer la gestion des déchets dangereux et/ou contenant des données sensibles, afin de garantir leur traitement conforme aux normes de sécurité et de confidentialité en vigueur.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '2-Définitions\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Déchets dangereux : Toute substance ou objet présentant un danger pour la santé humaine ou l\'environnement.\nDonnées sensibles : Toute information dont la divulgation non autorisée pourrait entraîner un risque pour la vie privée, la sécurité ou les intérêts de l\'individu ou de l\'organisation concernée.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '3-Obligations de l\'Utilisateur\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'L\'utilisateur de cette licence s\'engage à :\n- Manipuler, stocker et éliminer les déchets dangereux et les données sensibles conformément aux réglementations locales, nationales et internationales en vigueur.\n- Mettre en place des mesures de sécurité adéquates pour protéger les données sensibles contre tout accès non autorisé, perte, divulgation ou destruction.\n- Maintenir une documentation détaillée des procédures de gestion des déchets dangereux et des données sensibles.\n- Former le personnel impliqué dans la gestion de ces déchets aux bonnes pratiques et aux protocoles de sécurité.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '4-Responsabilités de l\'Utilisateur\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '- L\'utilisateur est entièrement responsable de toute perte, fuite ou divulgation non autorisée de données sensibles survenue pendant la gestion des déchets dangereux.\n- L\'utilisateur doit informer immédiatement l\'autorité compétente de toute violation de la sécurité des données ou incident de gestion des déchets.\n- L\'utilisateur s\'engage à indemniser toute personne ou organisation affectée par une violation de cette licence, y compris, mais sans s\'y limiter, les dommages financiers, les atteintes à la réputation et les coûts juridiques.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '5-Audits et Contrôles\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '- L\'utilisateur accepte de se soumettre à des audits réguliers par des organismes de contrôle accrédités pour vérifier la conformité aux termes de cette licence. Toute non-conformité découverte lors de ces audits devra être corrigée dans les meilleurs délais.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '6-Sanctions en Cas de Non-Respect\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '- En cas de non-respect des termes de cette licence, des sanctions pourront être appliquées, y compris, mais sans s\'y limiter :\n- Révocation de la licence.\n- Amendes financières.\n- Poursuites judiciaires.\n\n',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '7-Clause de Révision\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 95, 119, 94),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            '- Les termes de cette licence peuvent être révisés périodiquement pour refléter les évolutions des normes de sécurité et des réglementations. L\'utilisateur sera informé de toute modification et devra se conformer aux nouvelles exigences.',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Fermer',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 95, 119, 94),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              padding: const EdgeInsets.fromLTRB(19, 79, 19, 79),
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
                      SizedBox(height: 39),
                      //email
                      TextFormField(
                        controller: _email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'entrer votre email!';
                          } else if (!RegExp(r'^\w+(?:\.\w+)?@gmail\.com$')
                              .hasMatch(value)) {
                            return 'Entrez une adresse email valide!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'entrer votre email',
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

                      //mot de passe
                      TextFormField(
                        controller: _password,
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'entrer votre mot de passe!';
                          } else if (value.length < 6) {
                            return 'le mot de passe doit avoir au moin 6 caracteres!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'Entrer votre mot de passe',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 19),
                      //accepte les licences
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'J\'accepte ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: _showLicenceDialog,
                            child: Text(
                              'Les licences',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      //page suivante
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _registerAndNavigate,
                          child: const Text(
                            'S\'inscrire',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color.fromARGB(255, 6, 59, 8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 29),
                      //Vous avez deja un compte
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Vous avez deja un compte? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SeConnecter(),
                                ),
                              );
                            },
                            child: Text(
                              'Se connecter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
