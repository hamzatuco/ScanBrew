import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(90.0), // Change this height as needed
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(25.0)),
          child: AppBar(
            backgroundColor: const Color(0xffCEA35B)
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
                        '👋 Dobrodošli, Hamza Tuco',
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
                      onPressed: () {
                        // Implement logout functionality here
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
      body: Center(
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
                  maxHeight: 300,
                  minHeight: 100.0,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/animacija.json', // Replace with your JSON animation file path
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Dobrodosli na Scan Brew, upravljajte Vasim lokalom i vasim cijenama',
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

            const SizedBox(height: 40), // Spacer
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the button's action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15), // Adjust the radius as needed
                          ),
                        ),
                        child: Container(
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
                          // Handle the button's action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15), // Adjust the radius as needed
                          ),
                        ),
                        child: Container(
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
          ],
        ),
      ),
    );
  }
}
