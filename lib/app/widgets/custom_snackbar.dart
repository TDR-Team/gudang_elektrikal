import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gudang_elektrikal/app/common/theme/font.dart';

class CustomSnackbar {
  final bool success;
  final String title;
  final String message;
  final int duration;

  const CustomSnackbar({
    required this.success,
    required this.title,
    required this.message,
    this.duration = 3,
  });

  void showSnackbar() {
    final context = Get.context;

    if (context == null) {
      debugPrint(
        'CustomSnackbar tidak bisa ditampilkan karena Get.context null.',
      );
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint(
        'CustomSnackbar tidak bisa ditampilkan karena ScaffoldMessenger tidak ditemukan.',
      );
      return;
    }

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: boldText12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: regularText12,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
