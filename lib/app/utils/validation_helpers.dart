import 'package:get/get_utils/src/get_utils/get_utils.dart';

class ValidationHelpers {
  static String? validateEmail(String value) {
    if (value.isEmpty || value == '') {
      return 'Masukkan email kamu';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Masukkan email yang valid';
    }

    if (value.contains(' ') || value.contains('   ')) {
      return 'Email tidak boleh mengandung spasi';
    }
    return null;
  }

  static String? validatePassword({
    String value = '',
    bool isRegister = false,
  }) {
    if (value.isEmpty || value == '') {
      return 'Masukkan kata sandi';
    } else if (value.contains(' ')) {
      return 'Password tidak boleh mengandung spasi';
    } else if (!GetUtils.isLengthGreaterThan(value, 7)) {
      return 'Minimal 8 kata';
    } else if (!RegExp(r"^(?=.*[a-z])").hasMatch(value) && isRegister) {
      return "Masukkan 1 huruf kecil";
    } else if (!RegExp(r"^(?=.*[A-Z])").hasMatch(value) && isRegister) {
      return "Masukkan 1 huruf besar";
    } else if (!RegExp(r"^(?=.*\d)").hasMatch(value) && isRegister) {
      return "Masukkan setidaknya 1 angka";
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(
      {required String confirmPassword, required String password}) {
    if (confirmPassword.isEmpty || confirmPassword == '') {
      return 'Masukkan ulang kata sandi';
    } else if (confirmPassword != password) {
      return 'Kata sandi tidak sesuai!';
    } else {
      return null;
    }
  }

  static String? validateBankNumber({
    String value = '',
  }) {
    if (value.isEmpty || value == '') {
      return 'Nomor tidak boleh kosong!';
    } else if (!RegExp(r"^(?=.*\d)").hasMatch(value)) {
      return "Masukkan setidaknya 1 angka";
    } else if (value.length < 10) {
      return "Nomor bank harus setidaknya 10 digit";
    }
    return null;
  }

  static String? validateFirstName({
    String value = '',
  }) {
    if (value.isEmpty || value == ' ') {
      return 'Nama tidak boleh kosong';
    } else if (value.length < 4 || value.trim().length < 4) {
      return 'Minimal 4 karakter';
    } else if (RegExp(r'[0-9!@#$%^&*()_+{}\[\]:;<>,.?~\\-]').hasMatch(value)) {
      return 'Hapus angka atau simbol!';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? value) {
    if (value!.isEmpty || value == '') {
      return 'Nomor telepon tidak boleh kosong!';
    } else if (!RegExp(r"^(?=.*\d)").hasMatch(value)) {
      return "Masukkan setidaknya 1 angka";
    } else if (value.length < 9 || value.trim().length < 9) {
      return 'Minimal 9 angka';
    } else if (!RegExp(r'^08\d{1,12}$').hasMatch(value)) {
      return 'Nomor telepon tidak valid!';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value!.isEmpty || value == '') {
      return 'Alamat tidak boleh kosong!';
    } else if (!RegExp(r"^[a-zA-Z0-9\s,.'-]*$").hasMatch(value)) {
      return "Alamat hanya boleh berisi huruf dan angka!";
    } else if (value.length < 8) {
      return 'Masukkan alamat lebih detail!';
    } else if (value.length > 150) {
      return 'Maksimal 150 karakter!';
    }
    return null;
  }

  static String? validateLink(String value) {
    // Regular expression for a valid URL
    String pattern =
        r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return 'Please enter a URL';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? validatePhoneNumberNullable(String? value) {
    if (value!.isNotEmpty) {
      if (!RegExp(r'^08\d{1,12}$').hasMatch(value)) {
        return 'Nomor telepon tidak valid!';
      }
    }
    return null;
  }

  static bool isValidInteger(String input) {
    // Regular expression to match integer values, including leading zeros
    final regExp = RegExp(r'^[1-9]\d*$');
    return regExp.hasMatch(input);
  }
}
