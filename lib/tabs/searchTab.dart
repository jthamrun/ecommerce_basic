import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_basic/constants.dart';
import 'package:ecommerce_basic/pages/plantPage.dart';
import 'package:ecommerce_basic/firebase/firebaseServices.dart';
import 'package:ecommerce_basic/widgets/customInputField.dart';
import 'package:ecommerce_basic/widgets/plantData.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchQuery.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "Search Results",
                  style: Constants.TextDarkStyle,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsReference
                  .orderBy("searchQuery")
                  .startAt([_searchQuery]).endAt(["$_searchQuery\uf8ff"]).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                      body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(top: 128.0, bottom: 12.0),
                    children: snapshot.data.docs.map((document) {
                      return ProductCard(
                        name: document.data()['name'],
                        imageUrl: document.data()['images'][0],
                        price: "\$${document.data()["price"]}",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                        productId: document.id,
                                      )));
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
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: CustomInput(
              hintText: "Search here...",
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
