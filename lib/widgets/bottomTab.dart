import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabClicked;

  BottomTabs({
    this.selectedTab,
    this.tabClicked
  });

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0
          )
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabsButton(
            imagePath: "assets/images/home_button.png",
            isSelected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabClicked(0);
            },
          ),
          BottomTabsButton(
            imagePath: "assets/images/search_button.png",
            isSelected: _selectedTab == 1 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabClicked(1);
              });
            },
          ),
          BottomTabsButton(
            imagePath: "assets/images/save_button.png",
            isSelected: _selectedTab == 2 ? true : false,
            onPressed: () {
              setState(() {
                widget.tabClicked(2);
              });
            },
          ),
          BottomTabsButton(
            imagePath: "assets/images/logout_button.png",
            isSelected: _selectedTab == 3 ? true : false,
            onPressed: () {
              setState(() {
                FirebaseAuth.instance.signOut();
              });
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabsButton extends StatelessWidget {

  final String imagePath;
  final bool isSelected;
  final Function onPressed;

  BottomTabsButton({
    this.imagePath,
    this.isSelected,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    bool _isSelected = isSelected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 28.0,
          horizontal: 24.0
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _isSelected ? Theme.of(context).accentColor : Colors.transparent,
              width: 2.0,
            )
          )
        ),
        child: Image(
          width: 22.0,
          height: 22.0,
          color: _isSelected ? Theme.of(context).accentColor : Colors.black,
          image: AssetImage(
            imagePath ?? "assets/images/home_button.png"
          )
        )
      ),
    );
  }
}

