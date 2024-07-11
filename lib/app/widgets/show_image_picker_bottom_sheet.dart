import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/styles/colors.dart';

void showImagePickerBottomSheet({
  required Future Function({required bool isCamera}) onPickImage,
}) {
  showModalBottomSheet(
    context: Get.context!,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ambil Foto atau Gambar',
                style: TextStyle(
                  fontSize: 16,
                  color: kColorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    onPickImage(isCamera: true);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kamera',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    onPickImage(isCamera: false);
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kColorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Galeri',
                    style: TextStyle(
                      color: kColorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
