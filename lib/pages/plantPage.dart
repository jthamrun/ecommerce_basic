import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_basic/firebase/firebaseServices.dart';
import 'package:ecommerce_basic/widgets/actionBar.dart';
import 'package:ecommerce_basic/widgets/customImageSwipe.dart';
import 'package:ecommerce_basic/widgets/potSizeOptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedPotSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersReference.doc(_firebaseServices.getUserId()).collection("Cart").
      doc(widget.productId).set(
        {
          "size": _selectedPotSize
        }
      );
  }

  Future _addToSaved() {
    return _firebaseServices.usersReference.doc(_firebaseServices.getUserId()).collection("Saved").
    doc(widget.productId).set(
        {
          "size": _selectedPotSize
        }
    );
  }

  final SnackBar _cartSnackBar = SnackBar(content: Text("Product added to cart"),);
  final SnackBar _savedSnackBar = SnackBar(content: Text("Product Saved"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: _firebaseServices.productsReference.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                child: Text("Error: ${snapshot.error}"),
              ));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> documentData = snapshot.data.data();
              List imageList = documentData['images'];
              List potSizes = documentData['size'];

              _selectedPotSize = potSizes[0];

              return ListView(
                padding: EdgeInsets.all(0),
                children: [
                  ImageSwipe(imageList: imageList),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 24.0,
                      right: 24.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      "${documentData['name']}" ?? "Product Name",
                      style: Constants.TextBoldStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 24.0),
                    child: Text(
                      "\$${documentData['price']}" ?? "Price",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Text(
                      "${documentData['desc']}" ?? "Description",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 24.0),
                    child: Text(
                      "Select Pot Size",
                      style: Constants.TextDarkStyle,
                    ),
                  ),
                  PotSize(
                    potSizes: potSizes,
                    isSelected: (size) {
                      _selectedPotSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _addToSaved();
                            Scaffold.of(context).showSnackBar(_savedSnackBar);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0)),
                            width: 65.0,
                            height: 65.0,
                            alignment: Alignment.center,
                            child: Image(
                              height: 22.0,
                              image: AssetImage("assets/images/save_button.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _addToCart();
                              Scaffold.of(context).showSnackBar(_cartSnackBar);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)),
                              height: 65.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 16.0),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          },
        ),
        CustomActionBar(
          isBackArrow: true,
          isTitle: false,
          isBackground: false,
        )
      ],
    ));
  }
}
