// ignore_for_file: file_names, unused_import, import_of_legacy_library_into_null_safe, avoid_print

import 'package:scanbrew/Pages/dashboard.dart';
import 'package:scanbrew/Pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class Lozinka extends StatefulWidget {
  const Lozinka({super.key});

  @override
  State<Lozinka> createState() => _LozinkaState();
}

final _emailController = TextEditingController();
String ime = '';

class _LozinkaState extends State<Lozinka> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/pozadina.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(-0.9, 0.5), // Shifted towards left
            ),
          ),
          Positioned(
            top: 70, // adjust the value here to move the text down
            left: 25,
            right: 25,
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Scan Brew',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    width: 30.0,
                    child: Divider(
                      color: Colors.white,
                      thickness: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                  child: Text(
                      'Unesite E-mail povezan sa Vasim racunom\na mi cemo Vam poslati link za obnovu lozinke',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Container(
                width: 350,
                height: 350,
                color: const Color.fromARGB(255, 90, 59, 48),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 120, 10, 0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 30, 0, 30),
                            ),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Divider(
                              color: Color.fromARGB(255, 75, 70, 70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 90,
                        color: const Color(0xff3D2821),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                  child: Text(
                                    'OBNOVITE LOZINKU',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 140,
                        color: const Color.fromARGB(255, 90, 59, 48),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: SizedBox(
                                    height: 65, //height of button
                                    width: 370,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffCEA35B),
                                      ),
                                      onPressed: () {
                                        resetPassword(context);
                                      },
                                      child: Text(
                                        'Resetujte lozinku',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Natrag na prijavu',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> resetPassword(BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    // Send a password reset email to the user's email address
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailController.text.trim(),
    );

    // Clear the text controller
    _emailController.clear();

    // Show a message to inform the user that a password reset email has been sent
    Fluttertoast.showToast(msg: 'Email za resetiranje lozinke je poslan.');

    // You can navigate to a different screen or handle UI accordingly
  } catch (e) {
    // Handle any errors that occur during the password reset process
    print(e);

    // Show an error message to the user
    Fluttertoast.showToast(msg: 'Korisnik ne postoji.');
  }
}
