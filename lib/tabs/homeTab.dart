import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_basic/pages/plantPage.dart';
import 'package:ecommerce_basic/firebase/firebaseServices.dart';
import 'package:ecommerce_basic/widgets/actionBar.dart';
import 'package:ecommerce_basic/widgets/plantData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class HomeTab extends StatelessWidget {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsReference.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                    body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ));
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(top: 108.0, bottom: 12.0),
                  children: snapshot.data.docs.map((document) {
                    return ProductCard(
                      name: document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: "\$${document.data()["price"]}",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productId: document.id,)
                        ));
                      },
                    );
                  }).toList(),
                );
              }

              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            },
          ),
          CustomActionBar(
            title: "Home",
            isBackArrow: false,
          )
        ],
      ),
    );
  }
}
