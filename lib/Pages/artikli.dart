import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: CafeDetailsPage()));
}

class CafeDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cafe Details")),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("kafici")
            .doc("kafic1")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text("Cafe not found.");
          }

          final cafeData = snapshot.data!.data();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cafe Name: ${cafeData?["Lokal"] ?? "N/A"}"),
              Text("Cafe Address: ${cafeData?["Adresa"] ?? "N/A"}"),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("kafici")
                    .doc("kafic1")
                    .collection("artikli")
                    .snapshots(),
                builder: (context, drinksSnapshot) {
                  if (drinksSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (drinksSnapshot.hasError) {
                    return Text("Error: ${drinksSnapshot.error}");
                  }

                  if (!drinksSnapshot.hasData ||
                      drinksSnapshot.data!.docs.isEmpty) {
                    return Text("No drinks found for this cafe.");
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Drinks:"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: drinksSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var drinkData =
                              drinksSnapshot.data!.docs[index].data();
                          final drinkName = drinkData?["Naziv"] ?? "N/A";
                          final drinkPrice = drinkData?["Cijena"] ?? "N/A";
                          return ListTile(
                            title: Text(drinkName),
                            subtitle: Text("Price: \$${drinkPrice}"),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
