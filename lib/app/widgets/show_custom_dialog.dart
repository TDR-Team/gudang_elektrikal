import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../common/styles/colors.dart';
import '../common/theme/font.dart';


void showCustomDialog({
  String type = 'error',
  required String title,
  required String message,
  void Function()? onClickedTrueButton,
  bool isBackAgain = false,
  String falseButtonText = 'Tidak',
  String trueButtonText = 'Ya',
  Color? color,
}) {
  final iconAsset = type == 'success'
      ? 'assets/icons/ic_success.svg'
      : 'assets/icons/ic_warning.svg';

  showDialog(
    context: Get.context!,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      return Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: size.height / 1.5,
            child: Stack(
              children: [
                _buildDialogContent(
                  size: size,
                  title: title,
                  message: message,
                  onClickedTrueButton: onClickedTrueButton,
                  color: color ?? const Color(0xFFC06247),
                  falseButtonText: falseButtonText,
                  trueButtonText: trueButtonText,
                ),
                _buildCloseButton(
                  size: size,
                  onClickedTrueButton: onClickedTrueButton,
                ),
                _buildIcon(
                  iconAsset: iconAsset,
                  size: size,
                  color: color ?? const Color(0xFFC06247),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then(
    (value) {
      if (isBackAgain) {
        Get.back();
      }
    },
  );
}

_buildIcon({
  required Size size,
  required String iconAsset,
  required Color? color,
}) {
  return Positioned.fill(
    top: (size.height * 0.16),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 75,
        height: 75,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: SvgPicture.asset(
          iconAsset,
          allowDrawingOutsideViewBox: false,
          colorFilter: (iconAsset == 'success' ||
                  iconAsset == 'assets/icons/ic_success.svg')
              ? ColorFilter.mode(
                  AppColors.secondaryColors[1],
                  BlendMode.srcIn,
                )
              : ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                ),
        ),
      ),
    ),
  );
}

_buildCloseButton({
  required Size size,
  required Function()? onClickedTrueButton,
}) {
  return Visibility(
    visible: onClickedTrueButton == null,
    child: Positioned(
      top: (size.height * 0.2),
      right: 4,
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.close_rounded,
        ),
      ),
    ),
  );
}

_buildDialogContent({
  required Size size,
  required String title,
  required String message,
  required String falseButtonText,
  required String trueButtonText,
  required Color color,
  required void Function()? onClickedTrueButton,
}) {
  return Positioned(
    top: (size.height * 0.2),
    left: 0,
    right: 0,
    child: Container(
      width: Get.width / 1.5,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          _buildTextTitle(title: title),
          const SizedBox(height: 6),
          _buildTextMessage(message: message),
          const SizedBox(height: 16),
          _buildNegativeAndPositiveButton(
            onClickedTrueButton: onClickedTrueButton,
            color: color,
            falseButtonText: falseButtonText,
            trueButtonText: trueButtonText,
          )
        ],
      ),
    ),
  );
}

Visibility _buildNegativeAndPositiveButton({
  required void Function()? onClickedTrueButton,
  required Color color,
  required String falseButtonText,
  required String trueButtonText,
}) {
  return Visibility(
    visible: onClickedTrueButton != null,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: color,
                width: 2,
              ),
              color: kColorScheme.background,
            ),
            child: Text(
              falseButtonText,
              style: semiBoldText14.copyWith(
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: onClickedTrueButton,
          child: Container(
            width: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 9,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: color,
            ),
            child: Text(
              trueButtonText,
              style: semiBoldText14.copyWith(
                color: kColorScheme.background,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_buildTextMessage({required String message}) {
  return Text(
    message,
    maxLines: 5,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: regularText12.copyWith(
      color: const Color(0xFF6F7975),
    ),
  );
}

_buildTextTitle({required String title}) {
  return Text(
    title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: mediumText16,
  );
}
