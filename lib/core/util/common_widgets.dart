import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import 'app_color.dart';

Widget text({
  String? text,
  double? size,
  Color? color,
  int? maxLines,
  TextAlign? textAlign,
  FontWeight? fontWeight,
  String? fontFamily,
  TextDecoration? decoration,
  TextOverflow? overFlow,
  double? wordSpacing,
  double? letterSpacing,
  TextDecorationStyle? decorationStyle,
  Color? decorationColor,
}) {
  return Text(
    text ?? '',
    maxLines: maxLines,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      color: color ?? AppColor.textColor,
      fontWeight: fontWeight,
      fontFamily: fontFamily ?? GoogleFonts.montserrat().fontFamily,
      decoration: decoration,
      decorationColor: decorationColor,
      overflow: overFlow,
      wordSpacing: wordSpacing,
      letterSpacing: letterSpacing,
      decorationStyle: decorationStyle,
    ),
  );
}

Widget button({
  double? height,
  double? width,
  Color? color,
  BorderRadius? borderRadius,
  String? name,
  Function()? onTap,
  double? fontSize = 17,
  Color? textColor = AppColor.white,
  Color borderColor = AppColor.appPrimary,
  bool isLoading = false,
  bool isIcon = false,
  String? image,
  FontWeight? fontWeight = FontWeight.bold,
  BuildContext? context,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? AppColor.appPrimary,
        borderRadius: borderRadius ?? BorderRadius.circular(9),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: isLoading
            ? const CupertinoActivityIndicator(color: AppColor.white)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isIcon) const Icon(Icons.add, color: AppColor.white, size: 20), // 👈 Icon shown conditionally
                  if (isIcon) const SizedBox(width: 8), // 👈 Spacing between icon and text
                  text(
                    text: name ?? 'Continue',
                    size: fontSize,
                    color: textColor,
                    fontWeight: fontWeight,
                    letterSpacing: 1,
                  ),
                ],
              ),
      ),
    ),
  );
}

image({
  required String url,
  double? height,
  double? width,
  BorderRadius? borderRadius, // Accept BorderRadius for flexible corner radii
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    imageBuilder: (context, imageProvider) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColor.black,
          borderRadius: borderRadius ?? BorderRadius.zero, // Default to no radius if null
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      );
    },
    placeholder: (context, url) => Center(
      child: SizedBox(
        height: height,
        width: width,
        child: Center(child: CircularProgressIndicator(color: AppColor.blueColor)),
      ),
    ),
    errorWidget: (context, url, error) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColor.black,
          borderRadius: borderRadius ?? BorderRadius.zero, // Default to no radius if null
        ),
        child: Image.network(
          height: height,
          width: width,
          'https://t4.ftcdn.net/jpg/04/95/28/65/240_F_495286577_rpsT2Shmr6g81hOhGXALhxWOfx1vOQBa.jpg',
          fit: BoxFit.cover,
        ),
      );
    },
  );
}

Widget buildCommonTextFormField({
  bool expands = false,
  Color borderColor = Colors.white38,
  required String hintText,
  Color hintTextColor = AppColor.hintTextColor,
  Widget? prefixIcon,
  Color color = AppColor.white,
  required TextInputType keyboardType,
  required TextInputAction textInputAction,
  String? Function(String?)? validator,
  int? maxLength,
  required TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters,
  EdgeInsetsGeometry? contentPadding = const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 10),
  bool obscureText = false,
  Widget? suffixIcon,
  void Function()? onTap,
  bool enabled = true,
  bool readOnly = false,
  double radius = 10,
  int? minLine,
  int? maxLine,
  FocusNode? focusNode,
  bool isFromChat = false,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  required BuildContext context,
  bool isFromPhoneText = false,
  TextAlignVertical textAlignVertical = TextAlignVertical.center,
  int hintTextSize = 13,
  Color? backgroundColor,
}) {
  final Color effectiveBgColor = backgroundColor ?? AppColor.transparent;

  return TextFormField(
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    onTapOutside: (event) => FocusScope.of(context).unfocus(),
    onTap: onTap,
    style: TextStyle(fontFamily: GoogleFonts.urbanist().fontFamily, color: color, fontSize: 14),
    expands: expands,
    keyboardType: keyboardType,
    obscureText: obscureText,
    textInputAction: textInputAction,
    enabled: enabled,
    focusNode: focusNode,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      counterText: '',
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: isFromPhoneText ? BorderSide.none : BorderSide(color: borderColor, width: 0.9),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: isFromPhoneText ? BorderSide.none : BorderSide(color: borderColor, width: 0.9),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: isFromPhoneText ? BorderSide.none : BorderSide(color: borderColor, width: 0.9),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: isFromPhoneText ? BorderSide.none : BorderSide(color: borderColor, width: 0.9),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      suffixIcon: suffixIcon,
      fillColor: effectiveBgColor, // ✅ Dynamic background
      filled: effectiveBgColor != Colors.transparent, // ✅ Fill only if not transparent
      hintText: hintText,
      hintStyle: TextStyle(
        color: hintTextColor,
        fontWeight: FontWeight.w400,
        fontSize: hintTextSize.toDouble(),
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      alignLabelWithHint: true,
    ),
    validator: validator,
    maxLength: maxLength,
    controller: controller,
    readOnly: readOnly,
    minLines: minLine,
    maxLines: maxLine,
    textAlignVertical: textAlignVertical,
  );
}
