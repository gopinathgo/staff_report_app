import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Admin%20Login/StaffsPage.dart';
import 'package:unicons/unicons.dart';
import 'StaffList.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {

  Future addUserDetails(String name, String email, String password, String phone,)async{
    await FirebaseFirestore.instance.collection('staff').add({
      'username':name,
      'email':email,
      'password':password,
      'phone':phone,
    });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


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
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffsPage()));        }, icon: Icon(UniconsLine.arrow_left,color: Colors.black,size: 45,)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 140,
                  ),
                  child: Text("STAFF REGISTER",
                      style: GoogleFonts.notoSerif(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 60,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.user,
                            size: 27,
                          ),
                          hintText: "Name"),
                      validator: valiateName,
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
                      validator: valiateEmail,
                      controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.envelope_minus,
                            size: 27,
                          ),
                          hintText: "Email"),
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
                      validator: valiatePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.lock,
                            size: 27,
                          ),
                          hintText: "Password"),
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
                      validator: valiatePhone,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.phone,
                            size: 27,
                          ),
                          hintText: "Phone"),
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,);
                      addUserDetails(
                        _nameController.text.trim()
                        , _emailController.text.trim()
                        , _passwordController.text.trim()
                        , _phoneController.text.trim(),
                      ).then((value) {
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _phoneController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Staff Details Successfully Added')),
                        );
                      });
                    }catch(e) {
                      print("error");
                    }
                  }
                },
                child: Text('ADD STAFF'),
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
Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffList()));
                },
                child: Text('STAFF LIST'),
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

String? valiateName(String? formEmail){
  if(formEmail == null || formEmail.isEmpty)
    return 'Username is required';


  String pattern = '([a-zA-Z])';
  RegExp regExp = RegExp(pattern);
  if(!regExp.hasMatch(formEmail)) return 'Invalid Username format';

  return null;
}
String? valiateEmail(String? formEmail){
  if(formEmail == null || formEmail.isEmpty)
    return 'E-mail address s required';


  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if(!regExp.hasMatch(formEmail)) return 'Invalid E-mail Address format';

  return null;
}
String? valiatePassword(String? formPassword){
  if(formPassword == null || formPassword.isEmpty)
    return 'Password is required';

  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  if(!regExp.hasMatch(formPassword)) return
    '''
    Password must be at least 8 characters,
    includ an uppercase letter , number and symbols.
  ''';

  return null;
}
String? valiatePhone(String? formPhone){
  if(formPhone == null || formPhone.isEmpty)
    return 'Phone number is required';


  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if(!regExp.hasMatch(formPhone)) return 'Invalid E-mail Address format';

  return null;
}
