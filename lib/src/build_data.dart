import 'package:dart2_constant/convert.dart';

/// convert ints and floats to numbers
getValue(String value) {
  try {
    num numValue = num.parse(value);
    if (!numValue.isNaN) {
      return numValue;
    } else {
      return value;
    }
  } on FormatException {
    if (value.startsWith('[') && value.endsWith(']')) {
      return json.decode(value);
    } else if (value.startsWith('{') && value.endsWith('}')) {
      return json.decode(value);
    } else if (value.trim().toLowerCase() == 'null') {
      return null;
    } else {
      return value;
    }
  }
}

/// Converts data from urlencoded to map
buildMapFromUri(Map map, String body) {
  RegExp parseArrayRgx = RegExp(r'^(.+)\[\]$');

  for (String keyValuePair in body.split('&')) {
    if (keyValuePair.contains('=')) {
      var equals = keyValuePair.indexOf('=');
      String key = Uri.decodeQueryComponent(keyValuePair.substring(0, equals));
      String value =
          Uri.decodeQueryComponent(keyValuePair.substring(equals + 1));

      if (parseArrayRgx.hasMatch(key)) {
        Match queryMatch = parseArrayRgx.firstMatch(key);
        key = queryMatch.group(1);
        if (!(map[key] is List)) {
          map[key] = [];
        }

        map[key].add(getValue(value));
      } else if (key.contains('.')) {
        // i.e. map.foo.bar => [map, foo, bar]
        List<String> keys = key.split('.');

        Map targetMap = map[keys[0]] ?? {};
        map[keys[0]] = targetMap;
        for (int i = 1; i < keys.length; i++) {
          if (i < keys.length - 1) {
            targetMap[keys[i]] = targetMap[keys[i]] ?? {};
            targetMap = targetMap[keys[i]] as Map;
          } else {
            targetMap[keys[i]] = getValue(value);
          }
        }
      } else {
        map[key] = getValue(value);
      }
    } else {
      map[Uri.decodeQueryComponent(keyValuePair)] = true;
    }
  }
}
