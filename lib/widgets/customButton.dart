import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlinedButton;
  final bool isLoading;

  CustomButton({
    this.text,
    this.onPressed,
    this.outlinedButton,
    this.isLoading
  });

  @override
  Widget build(BuildContext context) {

    bool _outlinedButton = outlinedButton ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          color: _outlinedButton ? Colors.transparent : Colors.black,
        ),
        // padding: EdgeInsets.symmetric(
        //   horizontal: 24.0,
        //   vertical: 12.0,
        // ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(
                  text ?? "Text",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _outlinedButton ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600
                  )
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
