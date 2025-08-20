extension IntExtensions on int {
  bool isLastIndex(int collectionLength) {
    if (collectionLength <= 0) {
      return false;
    }
    return this == collectionLength - 1;
  }
}
