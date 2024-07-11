bool isLinkedInUrlValid(String url) {
  RegExp regExp = RegExp(
    r"^(https?\:\/\/)?(www\.)?linkedin\.com\/.*$",
  );
  return regExp.hasMatch(url);
}
