import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PotSize extends StatefulWidget {
  final List potSizes;
  final Function(String) isSelected;

  PotSize({
    this.potSizes,
    this.isSelected
  });

  @override
  _PotSizeState createState() => _PotSizeState();
}

class _PotSizeState extends State<PotSize> {
  int _isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          for (var i = 0; i < widget.potSizes.length; i++)
            GestureDetector(
              onTap: () {
                widget.isSelected("${widget.potSizes[i]}");
                setState(() {
                  _isSelected = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                    color: _isSelected == i ? Theme.of(context).accentColor : Color(0xFFDCDCDC),
                    borderRadius: BorderRadius.circular(8.0)),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "${widget.potSizes[i]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isSelected == i ? Colors.white : Colors.black,
                    fontSize: 16.0
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
