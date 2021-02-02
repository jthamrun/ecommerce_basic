import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'homePage.dart';
import 'loginPage.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            )
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamSnapshot.error}"),
                    )
                );
              }

              // When connection state is active, check if user is logged in
              if (streamSnapshot.connectionState == ConnectionState.active) {
                User _user = streamSnapshot.data;

                if (_user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }

              return Scaffold(
                  body: Center(
                    child: Text(
                        "Verifying Authentication...",
                        style: Constants.HeadingStyle
                    ),
                  )
              );
            }
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Constants.HeadingStyle
            ),
          )
        );
      },
    );
  }
}
