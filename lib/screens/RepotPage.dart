import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Staff%20Login/Loginpage.dart';
import 'package:report_app/screens/StaffReport.dart';
import 'individual.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 50,
                  ),
                  child: Text("REPORTS",
                      style: GoogleFonts.notoSerif(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 250,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffReport()));
                },
                child: Text('STAFF REPORT'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.black,
                    textStyle: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Individual()));
                },
                child: Text('REPORT LIST'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.black,
                    textStyle: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>LogiPage())));
                  ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout The Account')),
                      );
                },
                child: Text('LOGOUT'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.black,
                    textStyle: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
