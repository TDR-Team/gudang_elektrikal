import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/logging.dart';

Future<XFile?> pickImageFromCamera() async {
  try {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear, // Request the rear camera
    );
    return pickedImage;
  } on PlatformException catch (e) {
    // Handle platform-specific errors (e.g., permissions denied)
    log.e('Error picking image: $e');
    return null;
  }
}

Future<XFile?> pickImageFromGallery() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

Future<XFile?> compressImageForApi(XFile imageFile) async {
  XFile? compressedImage = imageFile;
  int quality = 95;
  int iteration = 0;
  const int targetSize = 3000000; // 3 MB

  File tempFile = File(compressedImage.path);

  // Remove the file extension from the original path

  while (
      File(compressedImage!.path).lengthSync() > targetSize && quality > 20) {
    String tempFilePathWithoutExtension = tempFile.absolute.path
        .replaceAll(RegExp(r'(_[0-9]+_compressed|\.jpg$)'), '');

    // Create the new path by appending 'compressed.jpg'
    String compressedFilePath =
        '${tempFilePathWithoutExtension}_${iteration}_compressed.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      tempFile.absolute.path,
      compressedFilePath,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      // If the compression fails, break the loop and return null
      break;
    }

    compressedImage = XFile(result.path);

    log.i(
        'Size of the file $iteration : ${File(compressedImage.path).lengthSync()}');
    tempFile = File(result.path);
    quality -= 5;
    iteration += 1;

    // Prevent an infinite loop by ensuring quality does not go below a threshold
    if (quality <= 5) {
      break;
    }
  }

  // Check final size and ensure it's under the target size
  if (File(compressedImage.path).lengthSync() <= targetSize) {
    return compressedImage;
  } else {
    return null;
  }
}

Future<CroppedFile?> croppingImage({
  required XFile imageFile,
  CropStyle cropStyle = CropStyle.rectangle,
  CropAspectRatio ratio = const CropAspectRatio(ratioX: 1, ratioY: 1),
}) async {
  return await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    // cropStyle: cropStyle,

    aspectRatio: ratio,
    uiSettings: [
      AndroidUiSettings(
        cropGridStrokeWidth: 2,
        toolbarTitle: 'Edit Foto',
        lockAspectRatio: true,
        hideBottomControls: true,
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioLockEnabled: true,
        hidesNavigationBar: true,
      ),
    ],
  );
}
