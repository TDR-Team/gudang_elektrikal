bool isInstagramUrlValid(String url) {
  RegExp regExp = RegExp(
    r"^(https?:\/\/)?(www\.)?(instagram\.com|instagr\.am)\/[a-zA-Z0-9_\-\.]+(?:\/[a-zA-Z0-9_\-\.]+)*\/?(?:\?[\w=&%]+)?$",
  );
  return regExp.hasMatch(url);
}
