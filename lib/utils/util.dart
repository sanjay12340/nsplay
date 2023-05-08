class Util {
  static bool isNullTrue({dynamic value}) {
    if (value == null) {
      return true;
    } else {
      if (value.runtimeType == String) {
        return (value == "1") ? true : false;
      } else {
        return (value == 1) ? true : false;
      }
    }
  }

  static bool isNullFalse({dynamic value}) {
    if (value == null) {
      print("::::Null");
      return false;
    } else {
      if (value.runtimeType == String) {
        print("::::Null String");
        return (value == "1") ? true : false;
      } else {
        print("::::Null Integer");
        return (value == 1) ? true : false;
      }
    }
  }
}
