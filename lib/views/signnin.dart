import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUSerInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);

      databaseMethods.getUserByEmail(emailController.text).then((value) {
        snapshotUSerInfo = value;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUSerInfo.documents[0].data['name']);
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailPassword(
              emailController.text, passwordController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/logo.png"),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)
                            ? null
                            : "Please Enter Valid Email id";
                      },
                      controller: emailController,
                      style: textStyle(),
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration('Email'),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      validator: (value) {
                        return value.length < 6
                            ? "Please Enter Password 6+ charactrs"
                            : null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      style: textStyle(),
                      decoration: inputDecoration('Password'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    'Forget Password?',
                    style: textStyle(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: myButton(context, 'Sign In'),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                child: myButton(context, 'Sign In With Google'),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have accuount? ",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Text(
                      " Register now!",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
