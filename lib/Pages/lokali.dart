import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeListPage extends StatelessWidget {
  const CafeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('kafici').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final cafes = snapshot.data?.docs;

          return ListView.builder(
            itemCount: cafes?.length,
            itemBuilder: (context, index) {
              final cafe = cafes?[index].data() as Map<String, dynamic>;
              final imeVlasnika = cafe['Ime'] ?? 'N/A';
              final adresa = cafe['Adresa'] ?? 'N/A';
              final imeLokala = cafe['Lokal'] ?? 'N/A';

              return ListTile(
                title: Text('Ime vlasnika: $imeVlasnika'),
                subtitle: Text('Adresa: $adresa\nIme lokala: $imeLokala'),
              );
            },
          );
        },
      ),
    );
  }
}
