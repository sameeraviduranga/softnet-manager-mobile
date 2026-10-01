// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  bool isLoading = false;
  Color? backcolor;
  Color? textColor;
  CustomButton({
    super.key,
    this.onPressed,
    this.child,
    isLoading,
    this.backcolor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          backgroundColor: backcolor,
          foregroundColor: textColor,
        ),
        onPressed: onPressed,
        child: isLoading ? CircularProgressIndicator() : child,
      ),
    );
  }
}
