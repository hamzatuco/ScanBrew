import 'package:caffeadmin/Pages/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(title: const Text("Cafe Details")),
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
                  Text("Cafe Name: ${cafeData?["Lokal"] ?? "N/A"}"),
                  Text("Cafe Address: ${cafeData?["Adresa"] ?? "N/A"}"),
                  SizedBox(height: 20),
                  Text("Drinks:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: cafeDoc.reference.collection("artikli").snapshots(),
                    builder: (context, artikliSnapshot) {
                      if (artikliSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (artikliSnapshot.hasError) {
                        return Text("Error: ${artikliSnapshot.error}");
                      }

                      final artikliDocs = artikliSnapshot.data!.docs;

                      if (artikliDocs.isEmpty) {
                        return const Text("No drinks found.");
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: artikliDocs.map((artikalDoc) {
                          final artikalData = artikalDoc.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Drink Name: ${artikalData?["Naziv"] ?? "N/A"}"),
                              Text("Price: ${artikalData?["Cijena"] ?? "N/A"}"),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      );
                    },
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
