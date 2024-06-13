import 'package:eco_clean/pages/bienvenu.dart';
import 'package:eco_clean/pages/collecteur/collecteur-c.dart';
import 'package:eco_clean/pages/fournisseur/fournisseur-f.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../authentification/firebase_auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    if (user != null) {
      Map<String, dynamic>? userData =
          await FirebaseAuthServices().getUserData(user!.uid);
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
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const Bienvenue(),
          ));
        });
      }
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const Bienvenue(),
        ));
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 190,
              height: 190,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
