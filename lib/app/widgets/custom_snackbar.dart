import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class CustomSnackbar extends StatelessWidget {
  final bool success;
  final String title;
  final String message;

  const CustomSnackbar({
    super.key,
    required this.success,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showSnackbar() {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.zero,
        borderRadius: 10,
        messageText: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: success ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  success ? Icons.check : Icons.error_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: boldText12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      message,
                      style: regularText12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        barBlur: 2,
        backgroundColor: Colors.grey[200]!.withOpacity(0.4),
        snackStyle: SnackStyle.FLOATING,
      ),
    );
  }
}
