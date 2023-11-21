
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

import 'individual.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String documentId;

  const UpdatePage({super.key, required this.data, required this.documentId});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {


  //Time method
  TimeOfDay selectedInTime = TimeOfDay.now();

  //out Time
  TimeOfDay selectedOutTime = TimeOfDay.now();

  //Date method
  DateTime selectedDate = DateTime.now();


  Future<void> fetchFirestoreData()async{
    try{
      final document = await FirebaseFirestore.instance.collection('sub').doc(widget.documentId).get();
      if(document.exists){
        final data= document.data() as Map<String, dynamic>;
       _staffController.text = data['staffname'] ?? '';
       _studController.text = data['studentname'] ?? '';
       _courController.text = data['course'] ?? '';
       _topicController.text = data['topic'] ?? '';
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document not found')));
      }

    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to:$error')));
    }
  }

  //date functionality
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
      });
    }
  }

  void updateFirestoreData() {
    String updatedStaffName = _staffController.text;
    String updatedStudentName = _studController.text;
    String updatedCourse = _courController.text;
    String updatedTopic = _topicController.text;
    String updatedInTime = formatTime(selectedInTime);
    String updatedOutTime = formatTime(selectedOutTime);
    String updatedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    FirebaseFirestore.instance.collection('sub').doc(widget.documentId).update({
      'staffname': updatedStaffName,
      'studentname': updatedStudentName,
      'course': updatedCourse,
      'topic': updatedTopic,
      'slectedInTime': updatedInTime,
      'slecteOutTime': updatedOutTime,
      'selectedDate': updatedDate,
    }).then((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Individual()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upadte to the successfully")));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update data: $error'),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }



  //Time functionality
  Future<void> _selectInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedInTime,
    );

    if (picked != null && picked != selectedInTime) {
      setState(() {
        selectedInTime = picked;
        print(selectedInTime);
      });
    }
  }
  Future<void> _selectOutTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedOutTime,
    );

    if (picked != null && picked != selectedOutTime) {
      setState(() {
        selectedOutTime = picked;
      });
    }
  }

  //Time formate
  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat.jm().format(dateTime); // Format in 12-hour with AM/PM
    return formattedTime;
  }

  //Controller
  TextEditingController _staffController = TextEditingController();
  TextEditingController _studController = TextEditingController();
  TextEditingController _courController = TextEditingController();
  TextEditingController _topicController = TextEditingController();


  final _formKey = GlobalKey<FormState>();


  final counterTextStyles = GoogleFonts.notoSerif(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.normal,
    ),
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        automaticallyImplyLeading: false,

        /*leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(UniconsLine.arrow_left,color: Colors.black,size: 45,)),*/
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 20,left: 20,),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top:50,
                  ),
                  child: Text("STAFF LOGIN",
                      style: GoogleFonts.notoSerif(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: 30,
                          left: 30,
                        ),
                        child: TextFormField(
                          controller: _staffController,
                          decoration: InputDecoration(
                              hintText: "Staff Name",hintStyle: counterTextStyles),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 30,
                          left: 30,
                        ),
                        child: TextFormField(
                          controller: _studController,
                          decoration: InputDecoration(
                              hintText: "Student Name",hintStyle: counterTextStyles),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 30,
                          left: 30,
                        ),
                        child: TextFormField(
                          controller: _courController,
                          decoration: InputDecoration(
                              hintText: "Course",hintStyle: counterTextStyles),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: 30,
                          left: 30,
                        ),
                        child: TextFormField(
                          controller: _topicController,
                          decoration: InputDecoration(
                              hintText: "Topic",hintStyle: counterTextStyles),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()=>_selectInTime(context), child: Text("Choose In Time",style: GoogleFonts.notoSerif(
                      fontSize: 16
                  )),style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(150, 45),
                  )),
                  SizedBox(child: Center(child: Text("TO",style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),)),width: 40,),
                  ElevatedButton(onPressed: ()=>_selectOutTime(context), child: Text("Choose Out Time",style: GoogleFonts.notoSerif(
                      fontSize: 16
                  )),style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(150, 45),
                  ),),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${selectedInTime.format(context)}',style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),),
                  SizedBox(width: 200,),
                  Text('${selectedOutTime.format(context)}',style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),),
                  // Text("$selectedOutTime"),
                ],),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: ()=>_selectDate(context), child: Text("Choose the Date",style: GoogleFonts.notoSerif(
                  fontSize: 16
              ),),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: const Size(150, 45),
              )),
              SizedBox(height: 10,),
              Text( "${selectedDate.toLocal()}".split(' ')[0],style: GoogleFonts.notoSerif(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              )),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateFirestoreData();
                  }
                },
                child: Text('UPDATE'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  primary: Colors.black,
                  textStyle: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
