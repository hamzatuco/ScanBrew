// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class CafeDetailsPage extends StatefulWidget {
  final String ime;

  const CafeDetailsPage({super.key, required this.ime});

  @override
  State<CafeDetailsPage> createState() => _CafeDetailsPageState();
}

List<String> categories = [
  "Topla pica",
  "Gazirana pica",
  "Prirodni sokovi",
  "Alkoholna pica",
  "Pivo",
  "Vodene lule",
];
String selectedCategory = categories[0]; // Initialize with the first category

class _CafeDetailsPageState extends State<CafeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final String imeFromDashboard = widget.ime;
// Firestore document reference

    return Scaffold(
      body: FutureBuilder<String>(
        future: getVlasnikIDFromIme(imeFromDashboard),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          final vlasnikID = snapshot.data;

          print("Ime sa dashboard: $imeFromDashboard"); // Debug print
          print("Fetched vlasnikID: $vlasnikID"); // Debug print

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("kafici")
                .where("Ime", isEqualTo: imeFromDashboard)
                .limit(1)
                .snapshots(),
            builder: (context, cafeSnapshot) {
              print(
                  "CafeSnapshot connection state: ${cafeSnapshot.connectionState}"); // Debug print

              if (cafeSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (cafeSnapshot.hasError) {
                return Text("Error: ${cafeSnapshot.error}");
              }

              if (cafeSnapshot.data == null ||
                  cafeSnapshot.data!.docs.isEmpty) {
                return const Text("Lokal nije pronadjen");
              }
              final cafeDoc = cafeSnapshot.data!.docs.first;

              final cafeData = cafeSnapshot.data!.docs.first.data();

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(25.0)),
                        child: AppBar(
                          toolbarHeight: 125,
                          automaticallyImplyLeading: false,
                          backgroundColor:
                              const Color.fromARGB(255, 93, 53, 38),
                          title: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Center text horizontally
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: Text(
                                        "${cafeData["Lokal"] ?? "N/A"}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      // Center the "Adresa" text horizontally
                                      child: Text(
                                        "${cafeData["Adresa"] ?? "N/A"}",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Center(
                        child: Text(
                          "Cijene su izrazene u konvertibilnim markama (KM)",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 100.0,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: cafeDoc.reference
                                    .collection("artikli")
                                    .snapshots(),
                                builder: (context, artikliSnapshot) {
                                  if (artikliSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (artikliSnapshot.hasError) {
                                    return Text(
                                        "Error: ${artikliSnapshot.error}");
                                  }

                                  final artikliDocs =
                                      artikliSnapshot.data!.docs;

                                  if (artikliDocs.isEmpty) {
                                    return const Text(
                                        "Artikli nisu pronadjeni");
                                  }
                                  artikliDocs.sort((a, b) {
                                    final kategorijaA = a["Kategorija"] ?? "";
                                    final kategorijaB = b["Kategorija"] ?? "";
                                    return kategorijaA.compareTo(kategorijaB);
                                  });

                                  return Container(
                                    height: 650,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(
                                              2), // Adjust the width of the first column
                                          1: FlexColumnWidth(
                                              2), // Adjust the width of the second column
                                          2: FlexColumnWidth(
                                              1.3), // Adjust the width of the third column (delete button)
                                        },
                                        children: [
                                          for (var artikalDoc in artikliDocs)
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${artikalDoc["Naziv"] ?? "N/A"}",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${artikalDoc["Kategorija"] ?? "N/A"}", // Display the Kategorija value
                                                    style: GoogleFonts.poppins(
                                                      // You can customize the style as needed
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 3, 0, 0),
                                                  child: EditableCijenaWidget(
                                                    initialCijena:
                                                        "${artikalDoc["Cijena"] ?? "Nedefinisano"}",
                                                    onCijenaSaved: (newCijena) {
                                                      // Handle saving the new "Cijena" to the specific "artikli" document
                                                      final artikliRef = cafeDoc
                                                          .reference
                                                          .collection(
                                                              "artikli");
                                                      final artikalDocRef =
                                                          artikliRef.doc(artikalDoc
                                                              .id); // Assuming the document ID matches the product name
                                                      artikalDocRef.update({
                                                        "Cijena": newCijena
                                                      }).then((_) {
                                                        // Database update successful
                                                        print(
                                                            "Cijena uspjesno azurirana: $newCijena");
                                                      }).catchError((error) {
                                                        // Handle any errors that occur during the update
                                                        print(
                                                            "Error updating Cijena: $error");
                                                      });
                                                    },
                                                    cafeDocRef:
                                                        cafeDoc.reference,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 3, 0, 0),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size:
                                                          20, // Set the size of the icon
                                                    ),
                                                    onPressed: () {
                                                      _deleteArtikal(
                                                          artikalDoc.id,
                                                          cafeDoc.reference);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _showAddArtikalDialog(context, cafeDoc);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 93, 53, 38), // Button background color
                            minimumSize:
                                Size(80, 50), // Button width and height
                          ),
                          child: Text(
                            "Dodaj Artikal",
                            style: GoogleFonts.poppins(
                              color: Colors.white, // Text color
                              fontSize: 16, // Text font size
                              fontWeight: FontWeight.w500, // Text font weight
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteArtikal(String artikalId, DocumentReference cafeDocRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Potvrda brisanja"),
          content:
              const Text("Da li ste sigurni da želite izbrisati ovaj artikal?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete the item
                final artikliRef = cafeDocRef.collection("artikli");
                artikliRef.doc(artikalId).delete().then((_) {
                  // Row deleted successfully
                  print("Artikal deleted successfully");
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((error) {
                  // Handle any errors that occur during deletion
                  print("Error deleting artikal: $error");
                  Navigator.of(context).pop(); // Close the dialog
                });
              },
              child: const Text("Izbriši"),
            ),
          ],
        );
      },
    );
  }

  Future<String> getVlasnikIDFromIme(String ime) async {
    final usersRef = FirebaseFirestore.instance.collection("users");
    final querySnapshot = await usersRef.where("Ime", isEqualTo: ime).get();

    if (querySnapshot.size == 1) {
      final vlasnikID = querySnapshot.docs[0].id;
      return vlasnikID;
    } else if (querySnapshot.size > 1) {
      throw Exception(
          "MPronadjeni su vise korisnika sa istim korisnickim imenom.");
    } else {
      throw Exception("Korisnik nije pronadjen.");
    }
  }

  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _cijenaController = TextEditingController();
  final TextEditingController _ikonicaController = TextEditingController();

  void _showAddArtikalDialog(BuildContext context, DocumentSnapshot cafeDoc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dodaj novi artikal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nazivController,
                decoration: const InputDecoration(labelText: "Naziv"),
                onChanged: (value) {},
              ),
              TextFormField(
                controller: _cijenaController,
                decoration: const InputDecoration(labelText: "Cijena"),
                onChanged: (value) {},
              ),
              TextFormField(
                // Add this TextFormField for "Link ikonice"
                controller: _ikonicaController,
                decoration: const InputDecoration(labelText: "Link ikonice"),
                onChanged: (value) {},
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: "Kategorija"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              onPressed: () {
                String kategorija = selectedCategory;
                _addNewArtikal(cafeDoc, kategorija);
                Navigator.of(context).pop();
              },
              child: const Text("Dodaj"),
            ),
          ],
        );
      },
    );
  }

  void _addNewArtikal(DocumentSnapshot cafeDoc, String kategorija) {
    final newNaziv = _nazivController.text;
    final newCijena = _cijenaController.text;
    final newIkonica =
        _ikonicaController.text; // Get the value of the "Link ikonice" field

    if (newNaziv.isEmpty || newCijena.isEmpty) {
      return;
    }

    final artikliRef = cafeDoc.reference.collection("artikli");
    artikliRef.add({
      "Naziv": newNaziv,
      "Cijena": newCijena,
      "Kategorija": kategorija,
      "imageUrl": newIkonica, // Add the "Link ikonice" field
    }).then((_) {
      print(
        "Novi artikal dodan: $newNaziv, $newCijena KM, kategorija: $kategorija, Link ikonice: $newIkonica",
      );
    }).catchError((error) {
      print("Error adding new artikal: $error");
    });

    _nazivController.clear();
    _cijenaController.clear();
    _ikonicaController.clear(); // Clear the "Link ikonice" field
  }
}

class EditableCijenaWidget extends StatefulWidget {
  final String initialCijena;
  final void Function(String newCijena) onCijenaSaved;
  final DocumentReference cafeDocRef; // Firestore document reference

  const EditableCijenaWidget({
    Key? key,
    required this.initialCijena,
    required this.onCijenaSaved,
    required this.cafeDocRef, // Pass the Firestore document reference
  }) : super(key: key);

  @override
  _EditableCijenaWidgetState createState() => _EditableCijenaWidgetState();
}

class _EditableCijenaWidgetState extends State<EditableCijenaWidget> {
  late TextEditingController _cijenaController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _cijenaController = TextEditingController(text: widget.initialCijena);
  }

  @override
  void dispose() {
    _cijenaController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _cijenaController.text = widget.initialCijena;
    });
  }

  void _saveCijena() {
    final newCijena = _cijenaController.text;
    setState(() {
      _isEditing = false;
    });

    widget.cafeDocRef.update({
      "Cijena": newCijena,
    }).then((_) {
      // Database update successful
      print("Cijena updated successfully: $newCijena");
      widget.onCijenaSaved(newCijena);
    }).catchError((error) {
      // Handle any errors that occur during the update
      print("Error updating Cijena: $error");
      // You might want to display an error message to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: !_isEditing,
          child: Text(
            _cijenaController.text,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Visibility(
          visible: _isEditing,
          child: Expanded(
            child: TextFormField(
              controller: _cijenaController,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (!_isEditing)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _startEditing,
          ),
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: _cancelEditing,
          ),
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: _saveCijena,
          ),
      ],
    );
  }
}
