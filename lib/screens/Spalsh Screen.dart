import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_app/Staff%20Login/Loginpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => LogiPage(),
            )
        )
    );
  }

  final Shader _linearGradient = const LinearGradient(
    colors: [Colors.red, Colors.purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 350, 0.0));

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
        body: Center(
          child: InkWell(
            // onTap: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => LogiPage()));
            // },
            child: Text(
              "Segolsys...",
              style: GoogleFonts.pacifico(
                fontSize: 35 + 5,
                foreground: Paint()..shader = _linearGradient,
              ),
            ),
          ),
        ),
    );
  }
}
