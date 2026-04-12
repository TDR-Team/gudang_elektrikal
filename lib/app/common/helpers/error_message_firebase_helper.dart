class ErrorMessageFirebaseHelper {
  String getMessageFromErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'invalid-credential':
        return 'Email atau password salah.';

      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';

      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';

      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';

      case 'email-already-in-use':
        return 'Email sudah terdaftar.';

      case 'weak-password':
        return 'Password terlalu lemah.';

      case 'operation-not-allowed':
        return 'Metode login tidak diizinkan.';

      case 'account-exists-with-different-credential':
        return 'Akun sudah terdaftar dengan metode login yang berbeda.';

      default:
        return 'Terjadi kesalahan. Mohon coba lagi.';
    }
  }
}
