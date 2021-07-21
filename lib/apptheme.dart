import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color skillNo = Color(0xBBEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color secBgColor = Color(0xFF1D232B);
  static const Color borderColor = Color(0xFFB99B5F);
  static const Color priBgColor = Color(0xFF111217);
  static const Color blueAccent = Color(0xFF14E4F2);
  static const Color yellowAccent = Color(0xFFD3B763);
  static const Color tranWhite = Color(0xFF4D4D4D);
  static const Color lineColor = Color(0xFF313131);
  static const Color cardColor = Color(0xFF202224);

  static const Color thirdBgColor = Color(0xFF0D0D11);

  static const Color activeIcon = Color(0xFFC4A569);
  static const Color normalIcon = Color(0xFFAAAAAA);

  static const Color wildCores = Color(0xFFE8DDBD);
  static const Color coolDown = Color(0xFFF0E6D2);
  static const Color coolDown2 = Color(0xFFB087D5);
  static const Color mana = Color(0xFF199BE6);
  static const Color physicalDamage = Color(0xFFEA8D34);
  static const Color damageDamage = Color(0xFFD45D25);
  static const Color attackSpeed = Color(0xFFFDE58E);

  static const Color shieldBreak = Color(0xFFF25D54);
  static const Color speed = Color(0xFFF0E6D2);
  static const Color criticalStrike = Color(0xFFE8341B);
  static const Color magicPenetration = Color(0xFFCE69FE);

  static const Color shield = Color(0xFFEDCE2E);
  static const Color magicDamage = Color(0xFF4EDEFF);
  static const Color abilityPower = Color(0xFF776BFF);
  static const Color health = Color(0xFF54B37A);
  static const Color healthPlus = Color(0xFF90f290);

  static const Color physicalvamp = Color(0xFFD31C3F);
  static const Color magicalvamp = Color(0xFFDE2D88);
  static const Color energy = Color(0xFFF2E766);
  static const Color invisibility = Color(0xFF9F6A96);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFFEEE6D2);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color labText = Color(0x80DBD2C0);
  static const Color labTextActive = Color(0xFFDBD2C0);

  static const Color labTextActive2 = Color(0x80DBD2C0);
  static const String fontName = 'SF-Pro';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle themeTitle = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

}
