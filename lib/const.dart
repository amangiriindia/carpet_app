import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class APIConstants {
  static const String API_URL = 'https://oac.onrender.com';
}

class AppStyles {
  // Colors
  static const Color primaryColorStart = Color(0xFF991F35); // #991F35
  static const Color primaryColorEnd = Color(0xFF330A12);   // #330A12
  static const Color primaryTextColor = Color(0xFF292929);  // #292929
  static const Color secondaryTextColorAlt = Color(0xFFABABAB); // #ABABAB
  static const Color secondaryTextColor = Color(0xFF3D3636); // #3D3636
  static const Color gradientStartColor = Color(0xFF000000); // #000000
  static const Color gradientEndColor = Color(0xFF666666);   // #666666
  static const Color backgroundPrimary = Color(0xFFFFFFFF); // #FFFFFF
  static const Color backgroundSecondry = Color(0xFFF1F1F1);   // #F1F1F1
  static const Color successColor = Color(0xFF28A745); // A green color for success
  static const Color errorColor = Color(0xFFDC3545);   // A red color for error



  // Button Gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment(-0.9968, -0.0668), // Equivalent to 167.14deg
    end: Alignment(1.9109, 1.0),       // Stops at 191.09%
    colors: [gradientStartColor, gradientEndColor],
  );

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft, // Adjust as necessary
    end: Alignment.bottomRight, // Adjust as necessary
    colors: [primaryColorStart, primaryColorEnd],
    stops: [0.192, 2.1677], // Adjust stops to match the percentages in the original gradient
  );

  // Font Families
  static const String primaryFontFamily = 'Poppins';
  static const String secondaryFontFamily = 'Roboto';

  // Text Sizes
  static const double headingTextSize = 18.0;
  static const double bodyTextSize = 16; // Adjusted for body text size
  static const double smallTextSize = 12.0;

  // Text Styles
  static const TextStyle headingTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: headingTextSize,
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
  );

  static const TextStyle primaryBodyTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyTextSize, // 11.79px
    fontWeight: FontWeight.w400, // 400 weight (normal)
    height: 1.5, // Line height calculation
    textBaseline: TextBaseline.alphabetic,
    color: primaryTextColor,
  );

  static const TextStyle secondaryBodyTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: smallTextSize, // 11.79px
    fontWeight: FontWeight.w400,
    height: 1.5,
    textBaseline: TextBaseline.alphabetic,
    color: secondaryTextColor,
  );

  static const TextStyle tertiaryBodyTextStyle = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: bodyTextSize, // 11.79px
    fontWeight: FontWeight.w400,
    height: 1.5,
    textBaseline: TextBaseline.alphabetic,
    color: secondaryTextColorAlt,
  );

  // Padding, Margins, and Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
}

class CommonFunction {
  static void showLoadingDialog(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center( // Center the loading indicator
        child: SpinKitFadingCircle(
          size: 50.0,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isOdd ? AppStyles.primaryColorStart : AppStyles.primaryColorEnd,
              ),
            );
          },
        ),
      );
    },
  );

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
  }

 static Widget showLoadingIndicator() {
    return Center(
      child: SpinKitThreeBounce(
        color: AppStyles.primaryColorStart,
        size: 20.0,
      ),
    );
  }

  static void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
