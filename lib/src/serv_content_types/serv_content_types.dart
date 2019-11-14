enum ServContentTypeEnum {
  MultipartFormData,
  ApplicationFormUrlEncoded,
  TextPlain,
  TextHtml,
  ApplicationJavascript,
  ApplicationJson,
}

ServContentTypeEnum ServContentType(String type) {
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
