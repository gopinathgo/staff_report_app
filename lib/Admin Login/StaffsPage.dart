import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Staff%20Login/Loginpage.dart';
import 'package:report_app/screens/AddStaff.dart';
import 'package:report_app/screens/AllReports.dart';

class StaffsPage extends StatefulWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  State<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends State<StaffsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white24,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('staff').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> staffDocs = snapshot.data!.docs;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 0,
                          ),
                          child: Text("STAFFS",
                              style: GoogleFonts.notoSerif(
                                  fontSize: 35, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 400,
                        child: ListView.builder(
                          itemCount: staffDocs.length,
                          itemBuilder: (context, index) {
                            final staff = staffDocs[index].data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: Container(
                                color: Color.fromARGB(255, 230, 246, 255),
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '$index',
                                        style: GoogleFonts.notoSerif(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      child: Text(
                                        staff['username'],
                                        style: GoogleFonts.notoSerif(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LogiPage()));
                        },
                        child: Text('LOGOUT'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          primary: Colors.black,
                          textStyle: GoogleFonts.notoSerif(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddStaff()));
                        },
                        child: Text('+ ADD STAFF'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          primary: Colors.black,
                          textStyle: GoogleFonts.notoSerif(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AllReports()));
                        },
                        child: Text('OVERALL REPORTS'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(200, 50),
                          primary: Colors.black,
                          textStyle: GoogleFonts.notoSerif(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
