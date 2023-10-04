import 'package:scanbrew/Pages/artikli.dart';
import 'package:scanbrew/Pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:scanbrew/Pages/lokali.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  final String ime;

  const Dashboard({Key? key, required this.ime}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
// Replace with actual value

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(90.0), // Change this height as needed
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(25.0)),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff5f3c1e)
                .withOpacity(0.9), // Set the specified color
            title: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '👋 Dobrodošli, ${widget.ime}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut(); // Sign out the user
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          // Navigate to the login page
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Login()), // Replace LoginPage with your login page
                        );
                      },
                      child: Text(
                        'Odjava',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                    maxHeight: 310,
                    minHeight: 100.0,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Lottie.network(
                            'https://lottie.host/7ee48986-127f-409a-9c56-dcfc9ff4a1be/qa54TvuLRm.json', // Replace with your JSON animation file path
                            width: 240,
                            height: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Text(
                            'Dobrodosli na Scan Brew, upravljajte Vasim lokalom i cijenama Vasih proizvoda',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Upravljanje',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 30.0,
                  child: Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                ),
              ),

              const SizedBox(height: 20), // Spacer
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CafeListPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Adjust the radius as needed
                            ),
                          ),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/lokal.png', // Replace with your actual image path
                                  width: 90,
                                  height: 90,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Lokal',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), // Spacer between buttons
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CafeDetailsPage(ime: widget.ime),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Adjust the radius as needed
                            ),
                          ),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/artikal.png', // Replace with your actual image path
                                  width: 75,
                                  height: 75,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Artikli',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Često postavljena pitanja',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: SizedBox(
                          width: 30.0,
                          child: Divider(
                            color: Colors.black,
                            thickness: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15), // 15px gap
                      GestureDetector(
                        onTap: () {
                          // Show dialog for "Kako dodati novi artikal"
                          _showAddArtikalDialog(context, widget.ime);
                        },
                        child: Center(
                          child: Text(
                            'Kako dodati novi artikal?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff5f3c1e),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15), // 15px gap
                      GestureDetector(
                        onTap: () {
                          // Show dialog for "Kako dodati novi artikal"
                          _showYouTubeDialog(context, widget.ime);
                        },
                        child: Center(
                          child: Text(
                            'Kako postaviti ikonicu za artikal?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff5f3c1e),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15), // 15px gap
                      GestureDetector(
                        onTap: () {
                          // Show dialog for "Kako dodati novi artikal"
                          _showMeniDialog(context, widget.ime);
                        },
                        child: Center(
                          child: Text(
                            'Kako dobiti QR meni?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff5f3c1e),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'ili',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextButton(
                  onPressed: () {
                    _showHelpDialog(context, widget.ime);
                  },
                  child: Text(
                    'ℹ️ Potrazite pomoc',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showHelpDialog(BuildContext context, String ime) {
  String selectedCategory = 'Zahtjev za izradu menia'; // Default selection
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          width: 500, // Set the width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Potrazite pomoc',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Kontaktirate kao: $ime', // Display "Kontaktirate kao: [ime]"
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Predmet:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: 'Predmet',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    // Add any other styling properties you want for the hint text here
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff5f3c1e), // Color when focused
                      width: 2.0, // Width of the underline when focused
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Color when not focused
                      width: 1.0, // Width of the underline when not focused
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Pomoc za:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff5f3c1e), // Color when focused
                      width: 2.0, // Width of the underline when focused
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Color when not focused
                      width: 1.0, // Width of the underline when not focused
                    ),
                  ),
                ),
                items: [
                  'Zahtjev za izradu menia',
                  'Problemi sa prijavom',
                  'Greska u dizajnu',
                  'Problemi sa serverom',
                  'Prijedlog za poboljsanje',
                  'Ostalo',
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedCategory = newValue!;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Poruka:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Poruka',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    // Add any other styling properties you want for the hint text here
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff5f3c1e), // Color when focused
                      width: 2.0, // Width of the underline when focused
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Color when not focused
                      width: 1.0, // Width of the underline when not focused
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 24.0), // Adjust button padding
            ),
            child: Text(
              'Odustani',
              style: GoogleFonts.poppins(
                color: const Color(0xff5f3c1e),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5f3c1e),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            child: Text(
              'Podnesi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              // Check if any field is empty
              if (subjectController.text.isEmpty ||
                  messageController.text.isEmpty) {
                // Display a toast message
                Fluttertoast.showToast(
                  msg: 'Molimo Vas popunite sva polja',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              } else {
                // Create a reference to your Firebase Firestore collection
                final CollectionReference porukeCollection =
                    FirebaseFirestore.instance.collection('poruke');

                // Prepare the data to be stored
                Map<String, dynamic> porukaData = {
                  'kontaktirano_kao': ime,
                  'predmet': subjectController.text,
                  'kategorija': selectedCategory,
                  'poruka': messageController.text,
                  'vrijeme': FieldValue
                      .serverTimestamp(), // Optional: Include a timestamp
                };

                // Add the data to Firestore
                await porukeCollection.add(porukaData);

                // Close the dialog
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

// Function to show the "Kako dodati novi artikal" dialog
// Function to show the "Kako dodati novi artikal" dialog
void _showAddArtikalDialog(BuildContext context, String ime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Kako dodati novi artikal?',
          style: GoogleFonts.poppins(
            color: const Color(0xff5f3c1e),
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SizedBox(
          width: 600,
          height: 170,
          child: Text(
            'Da biste dodali novi artikal u Vas lokal, potrebno je da se uputite na stranicu za upravljanje artiklima i na dnu stranice pristupite dugmetu koje vodi ka dijalogu koji od Vas trazi da unesete Naziv artikla, cijenu, ikonicu (sliku koja ce se pojaviti na meniu za taj artikal), kao i da odaberete kategoriju u kojoj ce se artikal pojaviti. Kada unesete sve potrebne podatke i kliknete Unesi, artikal ce biti unijet u bazu podataka i prikazat ce se na Vasem meniu.',
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 24.0), // Adjust button padding
            ),
            child: Text(
              'Trebam pomoc',
              style: GoogleFonts.poppins(
                color: const Color(0xff5f3c1e),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _showHelpDialog(context, ime);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5f3c1e),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            onPressed: () {
              // Handle "Shvatio sam" button click
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Shvatio sam',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _showMeniDialog(BuildContext context, String ime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Kako dodati novi artikal?',
          style: GoogleFonts.poppins(
            color: const Color(0xff5f3c1e),
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SizedBox(
          width: 600,
          height: 170,
          child: Text(
            'Kako biste dobili QR meni i finalni produkt, kao i dizajn fizickih menia sa QR kodom, potrebno je da kontaktirate razvojne programere aplikacije kako bi iste dobili u najkracem mogucem roku',
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 24.0), // Adjust button padding
            ),
            child: Text(
              'Kontaktirajte programera',
              style: GoogleFonts.poppins(
                color: const Color(0xff5f3c1e),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _showHelpDialog(context, ime);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5f3c1e),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            onPressed: () {
              // Handle "Shvatio sam" button click
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Shvatio sam',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _showYouTubeDialog(BuildContext context, String ime) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Kako postaviti ikonicu artikla?',
          style: GoogleFonts.poppins(
            color: const Color(0xff5f3c1e),
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SizedBox(
          width: 600,
          height: 170,
          child: GestureDetector(
            onTap: () async {
              const url =
                  'https://www.youtube.com/watch?v=hc9Ph9GswMc'; // Replace with your actual URL
              try {
                await launch(url);
              } catch (e) {}
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Kako biste dodali ikonicu (sliku) nekog artikla iz Vase ponude, potrebno je da preuzmete png sliku artikla sa interneta i uploadate je na svoj meni. Kako preuzeti ikonicu i objaviti je?',
                    style: GoogleFonts.poppins(),
                  ),
                  TextSpan(
                    text: ' Pogledajte na ovom linku',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff5f3c1e),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 24.0), // Adjust button padding
            ),
            child: Text(
              'Trebam pomoc',
              style: GoogleFonts.poppins(
                color: const Color(0xff5f3c1e),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _showHelpDialog(context, ime);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5f3c1e),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            onPressed: () {
              // Handle "Shvatio sam" button click
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Shvatio sam',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}
