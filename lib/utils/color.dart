import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ---------- BRAND COLORS (STATIC) ----------
const Color primaryColor = Color(0xffD42431);
const Color primaryBlueColor = Color(0xff1C274C);

/// ---------- THEME-AWARE COLORS ----------
Color get primaryBlack => Get.theme.textTheme.bodyLarge?.color ?? Colors.black;

Color get inverseColor =>
    Get.theme.textTheme.headlineSmall?.color ?? Colors.black;

Color get scaffoldBackground => Theme.of(Get.context!).scaffoldBackgroundColor;

Color get textGrey => Get.theme.textTheme.bodyMedium?.color ?? Colors.grey;

Color get textDarkGrey => Get.theme.textTheme.bodyLarge?.color ?? Colors.black;

Color get textLightGrey => Get.theme.textTheme.bodySmall?.color ?? Colors.grey;

Color? get textSmall => Get.theme.textTheme.bodySmall?.color;

Color get lightGrey => Get.theme.dividerColor;

Color get navBackground =>
    Get.theme.bottomNavigationBarTheme.backgroundColor ?? Get.theme.cardColor;
Color get mainTextGrey => Get.theme.textTheme.bodySmall?.color ?? Colors.grey;

/// ---------- STATUS COLORS (STATIC) ----------
const Color primaryGreen = Color(0xFF03AF29);
const Color secondaryGreen = Color(0xFFD4FFDD);

const Color primaryRed = Color(0xFFEE0101);
const Color secondaryRed = Color(0xFFFFD6D6);

const Color primaryOrange = Color(0xFFFF7C03);
const Color secondaryOrange = Color(0xFFFFE6CF);

const Color secondaryBlue = Color(0xFFD7DFFC);
const Color blueColor = Color(0xFF90CAF9);

const Color textColor = Color(0xFF0032E5);

/// ---------- INPUT BORDERS ----------
InputBorder get errorBorder => OutlineInputBorder(
  borderSide: const BorderSide(color: primaryRed),
  borderRadius: BorderRadius.circular(4),
);

InputBorder get enabledBorder => OutlineInputBorder(
  borderSide: BorderSide(color: Get.theme.dividerColor),
  borderRadius: BorderRadius.circular(4),
);

InputBorder get focusedBorder => OutlineInputBorder(
  borderSide: BorderSide(color: Get.theme.primaryColor),
  borderRadius: BorderRadius.circular(4),
);

const Color lightRed = Color(0xffFFDDDD);
const Color primaryGrey = Color(0xFFC4C4C4);
