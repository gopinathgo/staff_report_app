import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Admin%20Login/StaffsPage.dart';
import 'package:unicons/unicons.dart';

class AllReports extends StatefulWidget {
  const AllReports({Key? key});

  @override
  State<AllReports> createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StaffsPage()));
          },
          icon: Icon(UniconsLine.arrow_left, color: Colors.black, size: 45),
        ),
      ),
      body: Column(
        children: [
          Text("OVER ALL REPORTS",style:GoogleFonts.notoSerif(
            fontSize: 30,
            fontWeight: FontWeight.bold
          )),
          Container(
            margin: EdgeInsets.only(right: 20,left: 20,top: 50),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('sub').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final uniqueDates = snapshot.data!.docs
                    .map((doc) => (doc['selectedDate'] as String).split(' ')[0])
                    .toSet();

                return Column(
                  children: uniqueDates.map((date) {
                    final filteredDocuments = snapshot.data!.docs
                        .where((doc) => (doc['selectedDate'] as String).split(' ')[0] == date)
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: $date',
                          style: GoogleFonts.notoSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15,),
                        SingleChildScrollView(
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
                              DataColumn(label: Text('In Time', style: textstyleBold), numeric: false),
                              DataColumn(label: Text('Out Time', style: textstyleBold), numeric: false),
                              DataColumn(label: Text('Date', style: textstyleBold), numeric: false),
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
                              ]);
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
