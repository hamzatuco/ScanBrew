// ignore_for_file: file_names, unused_import, import_of_legacy_library_into_null_safe, avoid_print

import 'package:scanbrew/Pages/dashboard.dart';
import 'package:scanbrew/Pages/forgotpassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final _emailController = TextEditingController();
final _passwordController = TextEditingController();
String ime = '';
bool _isObscured = true;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/pozadina.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(-0.9, 0.5), // Shifted towards left
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Center(
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
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 0),
                    child: Text(
                        'Servis za upravljanje artikala i cijena \nu ugostiteljskim objektima',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 160, 20, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 350,
                          height: 440,
                          color: const Color.fromARGB(255, 90, 59, 48),
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 100, 10, 0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 30, 0, 30),
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
                                    TextFormField(
                                      obscureText: _isObscured,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Lozinka',
                                        labelStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 30, 0, 30),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: IconButton(
                                            icon: Icon(
                                              _isObscured
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 90,
                                color: const Color(0xff3D2821),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Text(
                                            'PRIJAVITE SE POMOĆU EMAIL-A',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: SizedBox(
                                              height: 65, //height of button
                                              width: 370,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffCEA35B),
                                                ),
                                                onPressed: () {
                                                  prijava(context);
                                                },
                                                child: Text(
                                                  'Prijava →]',
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Lozinka(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Zaboravili ste lozinku?',
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> prijava(BuildContext context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    // Authenticate the user
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Get the user's email from Firebase Authentication
    String userEmail = userCredential.user?.email ?? '';

    // Query the Firestore collection for the user's email
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('Email', isEqualTo: userEmail).get();

    if (querySnapshot.size > 0) {
      // The user's email exists in the Firestore collection
      // Extract the 'Ime' field from the Firestore document
      String ime = querySnapshot.docs[0].get('Ime') ?? '';

      // Clear the text controllers
      _emailController.clear();
      _passwordController.clear();

      // Navigate to the Dashboard page and pass the 'ime' parameter
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(ime: ime),
        ),
      );
    } else {
      // User's email not found in Firestore collection
      Fluttertoast.showToast(msg: 'Korisnik nije pronađen');
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase Authentication exceptions
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: 'Korisnik nije pronađen');
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Kriva lozinka');
    } else {
      Fluttertoast.showToast(msg: 'Greška prilikom prijave');
    }
  } catch (e) {
    // Handle other exceptions
    print(e);
  }
}
