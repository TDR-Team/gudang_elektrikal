import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/theme/font.dart';

void showWarningDialog(String title, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      return Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: size.height / 3,
            child: Stack(
              children: [
                Positioned(
                  top: (size.height * 0.2) / 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: Get.width / 1.5,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: regularText14.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          message,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: regularText14.copyWith(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 70,
                  child: Image.asset(
                    "assets/images/warning.png",
                    height: size.height * 0.2,
                    width: size.height * 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
