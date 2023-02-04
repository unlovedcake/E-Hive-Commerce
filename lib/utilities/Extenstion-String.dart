extension FancyNum on String {
  bool isURLValid() {
    return Uri.parse(this).isAbsolute;
  }
}
