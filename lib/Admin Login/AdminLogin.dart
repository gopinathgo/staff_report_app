import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Admin%20Login/StaffsPage.dart';
import 'package:report_app/Staff%20Login/Loginpage.dart';
import 'package:unicons/unicons.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final textstylenormal = GoogleFonts.notoSerif(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );


  TextEditingController _emailcontroller =  TextEditingController();
  TextEditingController _passwordcontroller =  TextEditingController();

  final Shader _linearGradient = const LinearGradient(
    colors: [Colors.red, Colors.purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 350, 0.0));

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white24,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LogiPage()));
        }, icon: Icon(UniconsLine.arrow_left,color: Colors.black,size: 45,)),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 150,
                  ),
                  child: Text("ADMIN LOGIN",
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
                    child: TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.envelope_minus,
                            size: 27,
                          ),
                          hintText: "Enter Your Email"),
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
                    child: TextField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            UniconsLine.lock,
                            size: 27,
                          ),
                          hintText: "Enter Your Password"),
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed:() {
                  if (_formKey.currentState!.validate()) {
                    if (_emailcontroller.text == "admin2023@gmail.com" &&
                        _passwordcontroller.text == "Admin@20") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StaffsPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid Credentials')),
                      );
                    }
                  }
                },
                child: Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.black,
                    textStyle: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                height: 230,
              ),
              Text("By"),
              SizedBox(height: 5,),
              Text(
                "Segolsys...",
                style: GoogleFonts.pacifico(
                  fontSize: 15,
                  foreground: Paint()..shader = _linearGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
