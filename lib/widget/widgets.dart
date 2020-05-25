import 'package:flutter/material.dart';

Widget appBar(BuildContext context,String title) {
  return AppBar(
    title: Text(title),
  );
}

InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
      ));
}

TextStyle textStyle() {
  return TextStyle(color: Colors.white, fontSize: 16.0);
}

Container myButton(BuildContext context,String label) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 20.0),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      gradient: LinearGradient(
        colors: [Colors.blue[300],Colors.pink[300]],
      ),
    ),
    child: Text(label,style: TextStyle(
      fontSize: 20.0,
      color: Colors.cyanAccent,
    ),),
  );
}
