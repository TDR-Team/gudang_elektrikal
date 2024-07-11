bool isYouTubeUrlValid(String url) {
  RegExp regExp =
      RegExp(r"^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$");
  if (regExp.hasMatch(url)) {
    return true;
  } else {
    return false;
  }
}
