import 'dart:ui';

class Colorss {

  static Color white_bg = HexColor("#f8f8f8");
  static Color grey_color = HexColor("#C7C7CC");
  static Color app_color = HexColor("#00FF78");
  static Color colorll1 = HexColor("#0EFF78");
  static Color colorll2 = HexColor("#00F5FF");
  static Color primary = HexColor("#00FF78");
  static Color purpal = HexColor("#5856d6");
  static Color orange = HexColor("#ff9500");
  static Color date_button = HexColor("#d1ffef");
  static Color gradient1 = HexColor("#0EFF79");
  static Color fontColor = HexColor("#FFFFFF");
  static Color toggle_green = HexColor("#34C759");
  static Color hgradient2 = HexColor("#000000");
  static Color hgradient1 = HexColor("#000000");

  static Color black = HexColor("#000000");
  static Color white = HexColor("#ffffff");

  static Color buttongradient1 = HexColor("#181E40");
  static Color buttongradient2 = HexColor("#65A7BE");

}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
