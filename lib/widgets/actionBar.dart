import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_basic/pages/cartPage.dart';
import 'package:ecommerce_basic/firebase/firebaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool isBackArrow;
  final bool isTitle;
  final bool isBackground;

  CustomActionBar({
    this.title,
    this.isBackArrow,
    this.isTitle,
    this.isBackground
  });

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    bool _isBackArrow = isBackArrow ?? false;
    bool _isTitle = isTitle ?? true;
    bool _isBackground = isBackground ?? true;

    return Container(
      decoration: BoxDecoration(
        gradient: _isBackground ? LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0)
          ],
          begin: Alignment(0, 0),
          end: Alignment(0, 1)
        ) : null
      ),
      padding: EdgeInsets.only(
        top: 56.0,
        left: 24.0,
        right: 24.0,
        bottom: 42.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                width: 42.0,
                height: 42.0,
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                    "assets/images/back_button.png"
                  ),
                  color: Colors.white,
                  width: 16.0,
                  height: 16.0,
                ),
          ),
            ),
          if (_isTitle)
            Text(
              title ?? "Action Bar",
              style: Constants.TextBoldStyle,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CartPage(),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0)
              ),
              width: 42.0,
              height: 42.0,
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _firebaseServices.usersReference.doc(_firebaseServices.getUserId()).collection("Cart").snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;
                  if (snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
                  return Text(
                    "$_totalItems" ?? "0",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                    ),
                  );
                },
              )
            ),
          )
        ],
      ),
    );
  }
}
