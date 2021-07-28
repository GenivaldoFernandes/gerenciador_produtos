import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colorClass.dart';

class CustomButtom1 extends StatefulWidget {
  String rotulo;
  VoidCallback fun;
  double width;
  double height;
  CustomButtom1(this.rotulo, this.fun, {this.width = 200.0, this.height = 60.0});

  @override
  _CustomButtom1State createState() => _CustomButtom1State(
      this.rotulo, this.fun, this.width, this.height,
  );
}

class _CustomButtom1State extends State<CustomButtom1> {
  String rotulo;
  VoidCallback fun;
  double width;
  double height;

  _CustomButtom1State(
      this.rotulo, this.fun, this.width, this.height,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: HexColor("#1D754F"),
        onPressed: this.fun,
        child: Center(
          widthFactor: 1,
          child: Text(
            this.rotulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
