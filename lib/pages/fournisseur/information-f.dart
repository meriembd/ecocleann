import 'dart:io';

import 'package:eco_clean/widget/partager.dart';
import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  final String quantite;
  final String? photo;
  final String? location;
  final String description;

  const Information({
    Key? key,
    required this.quantite,
    this.photo,
    this.location,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return partager(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Information',
                style: TextStyle(
                  fontSize: 39,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 21),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: Color.fromARGB(255, 105, 153, 111), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Quantité de Déchet: $quantite',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            if (photo != null)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 245, 218),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photo:$photo',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Image.file(File(photo!)),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            if (location != null)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Color.fromARGB(255, 105, 153, 111), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Localisation: $location',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: Color.fromARGB(255, 105, 153, 111), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Description: $description',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
