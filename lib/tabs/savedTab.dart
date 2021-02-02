import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_basic/pages/plantPage.dart';
import 'package:ecommerce_basic/firebase/firebaseServices.dart';
import 'package:ecommerce_basic/widgets/actionBar.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersReference
                .doc(_firebaseServices.getUserId()).collection("Saved").get(),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductPage(productId: document.id)
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsReference.doc(document.id).get(),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnapshot.error}"),
                              ),
                            );
                          }

                          if (productSnapshot.connectionState == ConnectionState.done) {
                            Map _productsInCartMap = productSnapshot.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productsInCartMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productsInCartMap['name']}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Text(
                                            "\$${_productsInCartMap['price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context).accentColor,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Pot Size - ${document.data()['size']}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
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
            isBackArrow: false,
            title: "Saved",
          )
        ],
      ),
    );
  }
}
