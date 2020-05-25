import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatRoom.dart';
import 'package:chatapp/widget/widgets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userMap = {
        "name": userNameController.text,
        "email": emailController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameController.text);

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(
          emailController.text, passwordController.text);

      databaseMethods.uploadUserInfo(userMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Register Here!',
                        style: TextStyle(color: Colors.amber, fontSize: 50.0),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 9,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty || value.length < 2
                                    ? "Please Enter Valid Username"
                                    : null;
                              },
                              controller: userNameController,
                              style: textStyle(),
                              decoration: inputDecoration('Username'),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Please Enter Valid Email id";
                              },
                              controller: emailController,
                              style: textStyle(),
                              decoration: inputDecoration('Email'),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                return value.length < 6
                                    ? "Please Enter Password 6+ charactrs"
                                    : null;
                              },
                              controller: passwordController,
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
                            signMeUp();
                          },
                          child: myButton(context, 'Sign Up')),
                      SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: myButton(context, 'Sign Up With Google')),
                      SizedBox(height: 40.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account? ",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              child: Text(
                                " SignIn now!",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
