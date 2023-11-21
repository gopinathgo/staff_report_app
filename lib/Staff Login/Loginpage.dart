import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Admin%20Login/AdminLogin.dart';
import 'package:report_app/screens/RepotPage.dart';
import 'package:unicons/unicons.dart';

class LogiPage extends StatefulWidget {
  const LogiPage({super.key});

  @override
  State<LogiPage> createState() => _LogiPageState();
}

class _LogiPageState extends State<LogiPage> {


  bool _isLoggingIn = false;
  bool passwordVisible = true;



  Future<void> _handleLogin() async {
    try {
      setState(() {
        _isLoggingIn = true; // Start the login process
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoggingIn = false; // Login process is complete
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage()));

    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoggingIn = false;
      });
      if (error.code == 'wrong-Email') {
        // setState(() {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Wrong password. Please try again')),
        //   );
        // });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong Email. Please try again')),
          );
        });
      }
      if (error.code == 'wrong-password') {
        // setState(() {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Wrong password. Please try again')),
        //   );
        // });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong Password. Please try again')),
          );
        });
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<bool> isUserAuthenticated() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null; // Returns true if the user is authenticated, otherwise false
  }

  @override
  void initState() {
    super.initState();

    // Check if the user is already authenticated when the page loads
    isUserAuthenticated().then((authenticated) {
      if (authenticated) {
        // User is already authenticated, navigate to the desired page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReportPage()), // Replace with your destination page
        );
      }
    });
  }

  final Shader _linearGradient = const LinearGradient(
    colors: [Colors.red, Colors.purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 350, 0.0));


  TextEditingController _emailController =  TextEditingController();
  TextEditingController _passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white24,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
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
                     validator: validateEmail,
                     keyboardType: TextInputType.emailAddress,
                     controller: _emailController,
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
                   child: TextFormField(
                     validator: valiatePassword,
                     obscureText: passwordVisible,
                     controller: _passwordController,
                     decoration: InputDecoration(
                         suffixIcon: InkWell(
                           onTap: () {
                             setState(() {
                               passwordVisible = !passwordVisible;
                             });
                           },
                           child: Icon(
                             passwordVisible
                                 ? Icons.visibility
                                 : Icons.visibility_off,
                           ),
                         ),
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
                onPressed: _isLoggingIn ? null : _handleLogin,
                child: _isLoggingIn
                    ? CircularProgressIndicator() // Show the progress indicator
                    : Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50),
                  primary: Colors.black,
                  textStyle: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLogin()));
                },
                child: Text('ADMIN'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    primary: Colors.black,
                    textStyle: GoogleFonts.notoSerif(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(
                height: 140,
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


  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E-mail address is required';
    }

    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(formEmail)) {
      return 'Invalid E-mail Address format';
    }

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
}
