import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import 'RepotPage.dart';
import 'UpdatePage.dart';

class Individual extends StatefulWidget {
  const Individual({Key? key}) : super(key: key);

  @override
  State<Individual> createState() => _IndividualState();
}

class _IndividualState extends State<Individual> {
  String userName = ''; // Define the userName variable

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    fetchDataUsingEmail();
  }

  Future<void> fetchDataUsingEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (user != null) {
      try {
        // Initialize Firestore
        final firestore = FirebaseFirestore.instance;

        CollectionReference usersCollection = firestore.collection('staff');

        QuerySnapshot querySnapshot = await usersCollection
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          final fetchedUserName = userData['name'] as String? ?? userData['username'];
          setState(() {
            userName = fetchedUserName;
          });
        }
        else {
          print("No data found for this user.");
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    } else {
      print("User is not authenticated.");
    }
  }

  final textstyleBold = GoogleFonts.notoSerif(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  final textstylenormal = GoogleFonts.notoSerif(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Replace this with your navigation logic.
            // This is an example of navigating to the ReportPage.
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReportPage()));
          },
          icon: Icon(
            UniconsLine.arrow_left,
            color: Colors.black,
            size: 45,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 50),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('sub').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final filteredDocuments = snapshot.data!.docs
                      .where((doc) => (doc['staffname'] as String) == userName)
                      .toList();

                  return Column(
                    children: [
                     /* Text(
                        'Name: $userName',
                        style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User Name: $userName',
                        style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                        child: Text(
                          "Over All Reports",
                          style: GoogleFonts.notoSerif(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border: const TableBorder(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                              bottom: BorderSide(color: Colors.grey, width: 0.5),
                              left: BorderSide(color: Colors.grey, width: 0.5),
                              right: BorderSide(color: Colors.grey, width: 0.5),
                              horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
                              verticalInside: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                            columns: <DataColumn>[
                              DataColumn(label: Text('Staff Name', style: textstyleBold)),
                              DataColumn(label: Text('Student Name', style: textstyleBold)),
                              DataColumn(label: Text('Course', style: textstyleBold)),
                              DataColumn(label: Text('Topic', style: textstyleBold)),
                              DataColumn(label: Text('Selected In Time', style: textstyleBold), numeric: false),
                              DataColumn(label: Text('Selected Out Time', style: textstyleBold), numeric: false),
                              DataColumn(label: Text('Selected Date', style: textstyleBold), numeric: false),
                              DataColumn(label: Text('Edit', style: textstyleBold), numeric: false),
                            ],
                            rows: filteredDocuments.map((document) {
                              final data = document.data() as Map<String, dynamic>;
                              final staffname = data['staffname'] as String;
                              final studentname = data['studentname'] as String;
                              final course = data['course'] as String;
                              final topic = data['topic'] as String;
                              final slectedInTime = data['slectedInTime'] as String;
                              final slecteOutTime = data['slecteOutTime'] as String;
                              final selectedDate = data['selectedDate'] as String;

                              return DataRow(cells: [
                                DataCell(Text(staffname, style: textstylenormal)),
                                DataCell(Text(studentname, style: textstylenormal)),
                                DataCell(Text(course, style: textstylenormal)),
                                DataCell(Text(topic, style: textstylenormal)),
                                DataCell(Text(slectedInTime, style: textstylenormal)),
                                DataCell(Text(slecteOutTime, style: textstylenormal)),
                                DataCell(Text(selectedDate, style: textstylenormal)),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      final documentId = document.id;
                                      // Replace this with your navigation logic to the UpdatePage.
                                      // This is an example of navigating to the UpdatePage.
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(data: data, documentId: documentId)));
                                    },
                                    child: Text('Edit'),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


