import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CafeDetailsPage extends StatefulWidget {
  final String ime;

  const CafeDetailsPage({super.key, required this.ime});

  @override
  State<CafeDetailsPage> createState() => _CafeDetailsPageState();
}

class _CafeDetailsPageState extends State<CafeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final String imeFromDashboard = widget.ime;

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

          print("imeFromDashboard: $imeFromDashboard"); // Debug print
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
                return const Text("Cafe not found.");
              }
              final cafeDoc = cafeSnapshot.data!.docs.first;

              final cafeData = cafeSnapshot.data!.docs.first.data();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(25.0)),
                      child: AppBar(
                        toolbarHeight: 125,
                        automaticallyImplyLeading: false,
                        backgroundColor: Color.fromARGB(255, 93, 53, 38),
                        title: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
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
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

                                final artikliDocs = artikliSnapshot.data!.docs;

                                if (artikliDocs.isEmpty) {
                                  return const Text("No drinks found.");
                                }

                                return Table(
                                  children: [
                                    for (var artikalDoc in artikliDocs)
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${artikalDoc["Naziv"] ?? "N/A"}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  color: Colors.black,
                                                  thickness: 1.0,
                                                  width: 16.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: EditableCijenaWidget(
                                              initialCijena:
                                                  "${artikalDoc["Cijena"] ?? "Nedefinisano"}",
                                              onCijenaSaved: (newCijena) {
                                                // Handle saving the new "Cijena" to the database here
                                                // Update the database with the newCijena value
                                              },
                                              cafeDocRef: cafeDoc
                                                  .reference, // Pass the Firestore document reference
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<String> getVlasnikIDFromIme(String ime) async {
    final usersRef = FirebaseFirestore.instance.collection("users");
    final querySnapshot = await usersRef.where("Ime", isEqualTo: ime).get();

    if (querySnapshot.size == 1) {
      final vlasnikID = querySnapshot.docs[0].id;
      return vlasnikID;
    } else if (querySnapshot.size > 1) {
      throw Exception("Multiple users found with the same name.");
    } else {
      throw Exception("User not found.");
    }
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
            icon: Icon(Icons.edit),
            onPressed: _startEditing,
          ),
        if (_isEditing)
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: _cancelEditing,
          ),
        if (_isEditing)
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _saveCijena,
          ),
      ],
    );
  }
}
