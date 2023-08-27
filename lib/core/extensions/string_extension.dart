extension StringExtension on String {
  // trim the string from middle if it is longer than maxLength
  String trimFromMiddle(int maxLength) {
    if (length <= maxLength) {
      return this;
    }

    int mid = maxLength ~/ 2;
    double rem = maxLength % 2 / 2;
    return '${substring(0, mid - rem.toInt())}...${substring(length - mid + rem.toInt())}';
  }
}
