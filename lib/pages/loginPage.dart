import 'package:ecommerce_basic/pages/registerPage.dart';
import 'package:ecommerce_basic/widgets/customButton.dart';
import 'package:ecommerce_basic/widgets/customInputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              title: Text("Error"),
              content: Container(
                child: Text(error),
              ),
              actions: [
                FlatButton(
                  child: Text("Close Dialog"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]
          );
        }
    );
  }

  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loggedInEmail,
          password: _loggedInPassword
      );
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async  {
    setState(() {
      _loginFormLoading = true;
    });

    String _loginAccountFeedback = await _loginAccount();
    if (_loginAccountFeedback != null) {
      _alertDialogBuilder(_loginAccountFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  bool _loginFormLoading = false;
  String _loggedInEmail = "";
  String _loggedInPassword = "";
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  "Welcome User, \nLogin to your account",
                  textAlign: TextAlign.center,
                  style: Constants.TextBoldStyle
                ),
              ),
              Column(
                  children: [
                    CustomInput(
                      hintText: "Email...",
                      onChanged: (value) {
                        _loggedInEmail = value;
                      },
                      onSubmitted: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Password...",
                      onChanged: (value) {
                        _loggedInPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value) {
                        _submitForm();
                      },
                    ),
                    CustomButton(
                      text: "Login",
                      onPressed: () {
                        _submitForm();
                      },
                      isLoading: _loginFormLoading,
                    )
                  ]
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CustomButton(
                  text: "Create New Account",
                  onPressed: () {
                    print("Create New Account Button Clicked!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage()
                      )
                    );
                  },
                  outlinedButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
