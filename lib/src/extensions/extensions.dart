
extension ObjectCheck on dynamic {
  bool get isEmptyObj  {
    if (this == null){
      return true;
    }
    if (this is List || this is String){
      return this is List? (this as List).isEmpty: (this as String).isEmpty;
    }
    if (this is num){
      return this == 0;
    }
    return false;
  }

  bool get isNotEmptyObj {
    return !(isEmptyObj);
}
}

extension StringFunctions on String {
  String get capitalizeFirstLetter {
    return '${this[0].toUpperCase()}${substring(1, length)}';
  }
}
