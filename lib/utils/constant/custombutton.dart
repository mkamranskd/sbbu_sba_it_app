import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class CustomButton extends StatelessWidget {
  final String text; // Button text
  final VoidCallback onPressed; // Action on press
  final Color textColor; // Text color
  final double fontSize; // Text size
  final Color? strokeColor; // Stroke color (optional)
  final double strokeWidth; // Stroke width

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.strokeColor,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 335,
        height: 50,
        decoration: BoxDecoration(
          color: ITColors.backgroundbar, // Background color
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: ITColors.barbackground, // Stroke color
            width: 2.0, // Stroke thickness
          ),// Rounded corners
        ),
        child: Stack(
          children: [
            Positioned(
              left: 110,
              top: 15,
              child: Stack(
                children: [
                  if (strokeColor != null && strokeWidth > 0) // Conditional stroke
                    Text(
                      textAlign: TextAlign.center,
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        height: 1, // Adjust height for alignment
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = strokeWidth
                          ..color = strokeColor!,
                      ),
                    ),
                  Text(
                    textAlign: TextAlign.center,
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      height: 1, // Adjust height for alignment
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
