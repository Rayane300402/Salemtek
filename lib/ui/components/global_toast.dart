import 'package:fluttertoast/fluttertoast.dart';
import 'package:salemtek/configs/theme/palette.dart';

class GlobalToast {
  GlobalToast._();

  static Future<bool?> show(
      String message, {
        bool isNegative = false,
      }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: isNegative ? Palette.navIcon : Palette.primary,
      textColor: Palette.secondary,
      fontSize: 16,
    );
  }
}