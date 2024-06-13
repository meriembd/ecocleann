import 'package:eco_clean/authentification/firebase_auth_services.dart';
import 'package:eco_clean/pages/collecteur/collecteur-c.dart';
import 'package:eco_clean/pages/collecteur/inscrire1-c.dart';
import 'package:eco_clean/pages/fournisseur/fournisseur-f.dart';
import 'package:eco_clean/widget/partager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SeConnecter extends StatefulWidget {
  const SeConnecter({Key? key}) : super(key: key);

  @override
  State<SeConnecter> createState() => _LogInState();
}

class _LogInState extends State<SeConnecter> {
  final _formLogInKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool remembermdp = true;
  final FirebaseAuthServices _authServices = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formLogInKey.currentState!.validate()) {
      User? user = await _authServices.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        String role = await _authServices.getUserRole(user.uid);
        role = role.toLowerCase(); // Make role case-insensitive

        // Fetch additional user data from Firestore
        Map<String, dynamic>? userData =
            await _authServices.getUserData(user.uid);

        if (role == 'collecteur') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CollecteurProfile(
                name: userData?['fullName'] ?? '',
                address: userData?['adresse'] ?? '',
                role: role,
                phone: userData?['phone'],
              ),
            ),
          );
        } else if (role == 'fournisseur') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FournisseurProfile(
                name: userData?['fullName'] ?? '',
                address: userData?['adresse'] ?? '',
                role: role,
                phone: userData?['phone'],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Role inconnu. Veuillez contacter l\'administrateur.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Échec de la connexion. Veuillez vérifier vos identifiants.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return partager(
      child: Column(
        children: [
          const Expanded(
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
                  key: _formLogInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 39,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 65, 105, 61),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // email
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrer votre email!';
                          } else if (!RegExp(r'^\w+(?:\.\w+)?@gmail\.com$')
                              .hasMatch(value)) {
                            return 'Entrez une adresse email valide!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 31, 87, 33),
                          ),
                          hintText: 'Entrer votre email',
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
                      const SizedBox(height: 25),
                      // mot de passe
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrer votre mot de passe!';
                          } else if (value.length < 6) {
                            return 'Le mot de passe doit avoir au moins 6 caractères!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Mot de passe'),
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 31, 87, 33),
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
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: remembermdp,
                                onChanged: (bool? value) {
                                  setState(() {
                                    remembermdp = value!;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              const Text(
                                'Souviens-toi de moi !',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: const Text(
                              'Mot de passe oublié?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            onTap: () {
                              // Reset password functionality
                              if (_emailController.text.isNotEmpty) {
                                _authServices
                                    .resetPassword(_emailController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Lien de réinitialisation de mot de passe envoyé!',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez entrer votre adresse email pour réinitialiser le mot de passe',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // page suivante
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 59, 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 19),
                      // vous n'avez pas un compte?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Vous n\'avez pas un compte?   ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const Inscrire1(),
                                ),
                              );
                            },
                            child: const Text(
                              'S\'inscrire',
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
          ),
        ],
      ),
    );
  }
}
