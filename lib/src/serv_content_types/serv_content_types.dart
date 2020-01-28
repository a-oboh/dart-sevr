enum ServContentTypeEnum {
  MultipartFormData,
  ApplicationFormUrlEncoded,
  TextPlain,
  TextHtml,
  ApplicationJavascript,
  ApplicationJson,
}

ServContentTypeEnum ServContentType(String type) {
  var types = [
    'application/x-www-form-urlencoded',
    'text/plain',
    'application/json',
    'text/html',
    'application/javascript',
    'multipart/form-data'

  ];
  for (var t in types){
    if (t.toLowerCase() == type.toLowerCase() || type.toLowerCase().contains(t.toLowerCase())){
      type = t;
      break;
    }
  };
  switch (type) {
    case 'application/x-www-form-urlencoded':
      return ServContentTypeEnum.ApplicationFormUrlEncoded;
    case 'text/plain':
      return ServContentTypeEnum.TextPlain;
    case 'application/json':
      return ServContentTypeEnum.ApplicationJson;
    case 'text/html':
      return ServContentTypeEnum.TextHtml;
    case 'application/javascript':
      return ServContentTypeEnum.ApplicationJavascript;
    case 'multipart/form-data':
      return ServContentTypeEnum.MultipartFormData;

    default:
      return null;
  }
}
