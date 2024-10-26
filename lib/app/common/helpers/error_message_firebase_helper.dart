class ErrorMessageFirebaseHelper {
  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email sudah terdaftar. Silakan ke halaman login.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Kombinasi email/password salah.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Tidak ada pengguna yang ditemukan dengan email ini.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Pengguna telah dinonaktifkan.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Terlalu banyak permintaan untuk masuk ke akun ini.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Kesalahan server, silakan coba lagi nanti.";
      case "channel-error":
        return "Email dan password tidak boleh kosong.";
      case "invalid-email":
        return "Email Anda tidak valid.";
      case "invalid-credential":
        return "Email atau password Anda salah.";
      default:
        return "Gagal masuk. Mohon coba lagi.";
    }
  }
}
