import 'package:flutter/material.dart';
import 'colors.dart';

final transparentButtonBlackBorder = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  side: const BorderSide(width: 0.8, color: Colors.black),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 0, 0, 0.1)),
));

final transparentButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  side: const BorderSide(width: 0.8, color: Color.fromRGBO(58, 151, 169, 1.0)),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(58, 151, 169, 1)),
));

final blackButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(58, 151, 169, 1)),
));

final primary500BorderButton = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  side: BorderSide(width: 1, color: kColorScheme.primary),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 0, 0, 0.1)),
));

final primary500Button = ElevatedButton.styleFrom(
  backgroundColor: kColorScheme.primary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide.none,
  ),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 0, 0, 0.1)),
));

final primary400Button = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(58, 151, 169, 1.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
).merge(ButtonStyle(
  overlayColor:
      WidgetStateProperty.all<Color>(const Color.fromRGBO(14, 89, 112, 1.0)),
));

final primary300Button = ElevatedButton.styleFrom(
  backgroundColor: kColorScheme.primary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  textStyle: const TextStyle(
    color: Colors.black,
  ),
).merge(ButtonStyle(
  backgroundColor: WidgetStateProperty.all<Color>(
    kColorScheme.primary,
  ),
  overlayColor: WidgetStateProperty.all<Color>(
    kColorScheme.onPrimary,
  ),
));

// final primary300Button = ButtonStyle(
//     backgroundColor: WidgetStatePropertyAll(kColorScheme.primary),
//     // overlayColor: WidgetStateProperty.all<Color>(
//     //   kColorScheme.primary,

//     // ),
//     padding: const WidgetStatePropertyAll(
//       EdgeInsets.symmetric(vertical: 16),
//     ));

final warning300Button = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xffFACA41),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
);
