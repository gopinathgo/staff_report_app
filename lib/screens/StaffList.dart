import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/screens/AddStaff.dart';
import 'package:unicons/unicons.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
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
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStaff()));          },
          icon: Icon(
            UniconsLine.arrow_left,
            color: Colors.black,
            size: 45,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final filteredDocuments = snapshot.data!.docs.where((document) {
            final data = document.data() as Map<String, dynamic>?;
            return data != null &&
                data.containsKey('username') &&
                data.containsKey('email') &&
                data.containsKey('password') &&
                data.containsKey('phone');
          });
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Text(
                  "Register List",
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
                      DataColumn(label: Text('Name', style: textstyleBold)),
                      DataColumn(label: Text('Email', style: textstyleBold)),
                      DataColumn(label: Text('Password', style: textstyleBold)),
                      DataColumn(label: Text('Phone', style: textstyleBold)),
                      DataColumn(label: Text('Delete', style: textstyleBold), numeric: false),
                    ],
                    rows: filteredDocuments.map((document) {
                      final data = document.data() as Map<String, dynamic>;
                      final username = data['username'] as String;
                      final email = data['email'] as String;
                      final password = data['password'] as String;
                      final phone = data['phone'] as String;

                      return DataRow(cells: [
                        DataCell(Text(username, style: textstylenormal)),
                        DataCell(Text(email, style: textstylenormal)),
                        DataCell(Text(password, style: textstylenormal)),
                        DataCell(Text(phone, style: textstylenormal)),
                        DataCell(
                          ElevatedButton(
                            onPressed: () async{
                              var collection = FirebaseFirestore.instance.collection('staff');
                              collection.doc(document.id).delete();
                           try{
                             FirebaseAuth.instance.currentUser!.delete();
                           }
                           catch(e){
                             print("Error");
                           }
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Remove the Account Successfully')),
                           );
                            },
                            child: Text('Remove'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red),
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
    );
  }
}
