import 'package:sevr/src/extensions/extensions.dart';
import 'package:meta/meta.dart';

class OpenApiGlobal {
  static Map<String, dynamic> global = {};
  static Map<String, dynamic> servers = {};
  static Map<String, dynamic> info = {};
  static Map<String, dynamic> paths = {};
  static Map<String, dynamic> components = {};
  static Map<String, dynamic> security = {};
  static Map<String, dynamic> tags = {};
}

enum OpenApiBodyType { requestBody }

enum OpenApiHttpMethod { post, get, patch, put }

/// Open Api Schema Property Object
class OpenApiProp {
  final String description;
  final String name;
  final Type type;
  final Type arrayOf;
  final dynamic example;
  final bool require;
  final bool isResp;
  final List<OpenApiProp> content;
  final String Function(dynamic value, String invalidMessage) validator;
  const OpenApiProp(
      {this.isResp = false,
      this.description,
      this.name,
      this.type,
      this.example,
      this.require = false,
      this.validator,
      this.arrayOf,
      this.content});

  Map<String, dynamic> _toJson() {
    var result = <String, dynamic>{};
    result['type'] = type == List
        ? 'array'
        : const {DateTime, String}.contains(type)
            ? 'string'
            : type == num
                ? 'number'
                : type == int ? 'integer' : type == bool ? 'boolean' : 'object';
    if (type == DateTime) {
      result['format'] = 'date time';
    }
    result['description'] = '$description';
    result['example'] = example;

    if (result['type'] == 'object') {
      if (content.isNotEmptyObj) {
        var properties = <String, dynamic>{}
        ..addEntries(content.map<MapEntry<String, dynamic>>((e) => e.toJsonEntry));
        result['properties'] = properties;
      } else {
        result['\$ref'] = '#/components/schemas/${name.capitalizeFirstLetter}';
      }
    }
    return result;
  }

  MapEntry<String, dynamic> get toJsonEntry => MapEntry(name, _toJson());
}

class OpenApiSchema {
  final String name;

  const OpenApiSchema({this.name});

  Map toJson() {
    return {'\$ref': '#/components/schemas/${name.capitalizeFirstLetter}'};
  }
}

class OpenApiContentType {
  static const String json = 'application/json';
}

class OpenApiContent {
  final String contentType;
  final OpenApiSchema openApiSchema;

  final Map example;

  Map _toJson() {
    var res = {'schema': openApiSchema.toJson(), 'example': example};
    return res;
  }

  MapEntry<String, dynamic> get toJsonEntry => MapEntry(contentType, _toJson());

  const OpenApiContent({this.contentType, this.openApiSchema, this.example});
}

class OpenApiReqBody {
  final OpenApiBodyType format;
  final String description;
  final List<OpenApiContent> content;

  String get getOpenApiBodyTypeInString {
    if (format == OpenApiBodyType.requestBody) return 'requestBody';
    return '';
  }

  Map get _toJson {
    var content = {};
    content.addEntries(this.content.map((e) => e.toJsonEntry));
    var res = {'description': '$description', 'content': content};
    return res;
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry(getOpenApiBodyTypeInString, _toJson);
  }

  const OpenApiReqBody({this.format, this.description, this.content});
}

class OpenApiRespContent {
  final List<OpenApiContent> content;
  final int statusCode;

  final String description;

  Map get _toJson {
    var content = {};
    content.addEntries(this.content.map((e) => e.toJsonEntry));
    return {'description': '$description', 'content': content};
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry('${statusCode}', _toJson);
  }

  const OpenApiRespContent({this.content, this.description, this.statusCode});
}

class OpenApiResp {
  final String respName;
  final List<OpenApiRespContent> responses;

  const OpenApiResp({this.responses, this.respName});

  Map get toJson {
    var responses = {};
    responses.addEntries(this.responses.map((e) => e.toJsonEntry));
    return responses;
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry('responses', toJson);
  }
}

OpenApiHttpMethod toOpenApiMethod(String method) {
  switch (method) {
    case 'post':
      return OpenApiHttpMethod.post;
    case 'get':
      return OpenApiHttpMethod.get;
    case 'put':
      return OpenApiHttpMethod.put;
    case 'patch':
      return OpenApiHttpMethod.patch;
    default:
      return OpenApiHttpMethod.get;
  }
}

class OpenApiParamObject {
  ///If in is "path", the name field MUST correspond to a template expression occurring within the path field in the Paths Object. See Path Templating for further information.
  ///If in is "header" and the name field is "Accept", "Content-Type" or "Authorization", the parameter definition SHALL be ignored.
  ///For all other cases, the name corresponds to the parameter name used by the in property.

  final String name;

  ///REQUIRED. The location of the Parameter key. Valid values are "query", "header" or "cookie".
  final OpenApiLocationType in_;

  ///A brief description of the parameter. This could contain examples of use. [CommonMark syntax](https://spec.commonmark.org/) MAY be used for rich text representation.
  final String description;

  ///Determines whether this parameter is mandatory.
  ///If the [parameter location]('https://swagger.io/specification/#parameter-in') is "path", this property is
  ///REQUIRED and its value MUST be true. Otherwise, the property MAY be included and its default value is false.
  final bool required_;

  ///Specifies that a parameter is deprecated and SHOULD be transitioned out of usage. Default value is false.
  final bool deprecated;

  ///Sets the ability to pass empty-valued parameters.
  ///This is valid only for query parameters and allows sending
  /// a parameter with an empty value. Default value is false. If style is used, and if behavior is n/a (cannot be serialized), the value of allowEmptyValue SHALL be ignored. Use of this property is NOT RECOMMENDED, as it is likely to be removed in a later revision.
  final bool allowEmptyValue;

  OpenApiParamObject(this.name, this.in_, this.description, this.required_,
      this.deprecated, this.allowEmptyValue);

  Map<String, dynamic> get toJson {
    return {
      'name': '$name',
      'in': '${in_.toString().split('.')[1]}',
      'description': '$description',
      'required': '$required',
      'deprecated': '$deprecated',
      'allowEmptyValue': '$allowEmptyValue'
    };
  }
}

class OpenApiMethod {
  final OpenApiHttpMethod method;
  final List<String> tags;
  final String summary;
  final String operationId;
  final OpenApiReqBody requestBody;
  final OpenApiResp responses;
  final bool deprecated;
  final List<OpenApiServerObject> servers;

  ///A list of parameters that are applicable for all the operations described under this path. These parameters can be overridden at the operation level, but cannot be removed there. The list MUST NOT include duplicated parameters. A unique parameter is defined by a combination of a name and location. The list can use the Reference Object to link to parameters that are defined at the OpenAPI Object's components/parameters.
  final List<OpenApiParamObject> parameters;

  Map get _toJson {
    var res = {
      'summary': '$summary',
      'operationId': operationId,
      'parameters': [...parameters.map((e) => e.toJson)],
      'deprecated': deprecated ?? false
    };
    if (servers.isNotEmptyObj) {
      res.addEntries([MapEntry('servers', servers.map((e) => e.toJson))]);
    }
    var entries = <MapEntry<String, dynamic>>[];
    if (requestBody.isNotEmptyObj) {
      entries.add(requestBody.toJsonEntry);
    }
    if (responses.isNotEmptyObj) {
      entries.add(responses.toJsonEntry);
    }
    res.addEntries(entries);
    return res;
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry(method.toString().split('.')[1], _toJson);
  }

  OpenApiMethod(
      {this.tags,
      this.method,
      this.summary,
      this.operationId,
      this.parameters,
      this.requestBody,
      @required this.responses,
      this.deprecated,
      this.servers});
}

class OpenApiPath {
  final String path;
  final String summary;
  final String description;
  final List<OpenApiMethod> methods;

  OpenApiPath({this.path, this.methods, this.summary, this.description});

  Map get _toJson {
    var res = <String, dynamic>{
      'summary': '$summary',
      'description': '$description'
    };
    res.addEntries([...methods.map((e) => e.toJsonEntry)]);
    return res;
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry(path.startsWith('/') ? path : '/$path', _toJson);
  }
}

class OpenApiContactObject {
  final String name;
  final String url;
  final String email;

  OpenApiContactObject({this.name, this.url, this.email});

  Map<String, dynamic> get toJson {
    return {'name': '$name', 'url': '$url', 'email': '$email'};
  }
}

class OpenApiServerVariableObject {
  final List<String> e_num;
  final String d_efault;
  final String description;

  OpenApiServerVariableObject({this.e_num, this.d_efault, this.description})
      : assert(e_num.contains(d_efault));

  Map<String, dynamic> get toJson {
    return {
      'enum': e_num,
      'default': '$d_efault',
      'description': '$description'
    };
  }
}

class OpenApiServerObject {
  final String url;
  final String description;
  final Map<String, OpenApiServerVariableObject> variables;

  OpenApiServerObject({this.url, this.description, this.variables});

  Map<String, dynamic> get toJson {
    var res = <String, dynamic>{
      'url': '$url',
      'description': '$description',
    };
    if (variables.isNotEmptyObj) {
      res.addEntries([
        MapEntry(
            'variables',
            {}..addAll(
                variables.map((key, value) => MapEntry('$key', value.toJson))))
      ]);
    }

    return res;
  }
}

class OpenApiLicenseObject {
  final String name;
  final String url;

  OpenApiLicenseObject({@required this.name, this.url});

  Map<String, dynamic> get toJson {
    return {'name': '$name', 'url': '$url'};
  }
}

class OpenApiMainInfo {
  final String title;
  final String description;
  final String version;
  final String termsOfService;
  final OpenApiContactObject contact;
  final OpenApiLicenseObject license;

  Map<String, dynamic> get toJson {
    return {
      'title': '$title',
      'description': '$description',
      'version': '$version',
      'termsOfService': '$termsOfService',
      'contact': contact.toJson,
      'license': license.toJson,
    };
  }

  OpenApiMainInfo({
    @required this.title,
    this.description,
    @required this.version,
    this.termsOfService,
    this.contact,
    this.license,
  });
}

class OpenApiTagObject {
  final String name;
  final String description;

  OpenApiTagObject({this.name, this.description});
}

class OpenApiSecurityRequirementObj {
  ///REQUIRED. The type of the security scheme. Valid values are "apiKey", "http", "oauth2", "openIdConnect".
  final OpenApiSecuritySchemaType type;

  ///A short description for security scheme. [CommonMark syntax](https://spec.commonmark.org/) MAY be used for rich text representation.
  final String description;

  ///REQUIRED. The name of the header, query or cookie parameter to be used.
  final String name;

  ///REQUIRED. The location of the API key. Valid values are "query", "header" or "cookie".
  final OpenApiLocationType in_;

  ///REQUIRED. The name of the HTTP Authorization scheme to be used in the [Authorization header as defined in RFC7235](https://tools.ietf.org/html/rfc7235#section-5.1).
  ///The values used SHOULD be registered in the [IANA Authentication Scheme registry](https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml). use the [OpenApiAuthScheme] static members
  final String scheme;

  ///A hint to the client to identify how the bearer token is formatted. Bearer tokens are usually generated by an authorization server, so this information is primarily for documentation purposes.
  final String bearerFormat;

  ///REQUIRED. An object containing configuration information for the flow types supported.

  final OauthFlowsObject flows;
  final String openIdConnectUrl;

  Map<String, dynamic> get toJson {
    return {
      'type': type.toString().split('.')[1],
      'description': '$description',
      'name': '$name',
      'in': '${in_.toString().split('.')[1]}',
      'scheme': '$scheme',
      'bearerFormat': '$bearerFormat',
      'flows': flows.toJson,
      'openIdConnectUrl': '$openIdConnectUrl'
    };
  }

  OpenApiSecurityRequirementObj(
      {this.type,
      this.description,
      this.name,
      this.in_,
      this.scheme,
      this.bearerFormat,
      @required this.flows,
      this.openIdConnectUrl});
}

enum OpenApiSecuritySchemaType { apiKey, http, oauth2, openIdConnect }

enum OpenApiLocationType { query, header, cookie }

class OauthFlowsObject {
  ///Configuration for the OAuth Implicit flow
  final OauthFlowObject implicit;

  ///Configuration for the OAuth Resource Owner Password flow
  final OauthFlowObject password;

  ///Configuration for the OAuth Client Credentials flow. Previously called application in OpenAPI 2.0.
  final OauthFlowObject clientCredentials;

  ///Configuration for the OAuth Authorization Code flow. Previously called accessCode in OpenAPI 2.0.
  final OauthFlowObject authorizationCode;

  OauthFlowsObject(
      {this.implicit,
      this.password,
      this.clientCredentials,
      this.authorizationCode});

  Map<String, dynamic> get toJson {
    return {
      'implicit': implicit.toJson,
      'password': password.toJson,
      'clientCredentials': clientCredentials.toJson,
      'authorizationCode': authorizationCode.toJson
    };
  }
}

class OauthFlowObject {
  final String authorizationUrl;
  final String tokenUrl;
  final String refreshUrl;
  final Map<String, String> scopes;

  OauthFlowObject(
      {this.authorizationUrl, this.tokenUrl, this.refreshUrl, this.scopes});

  Map<String, dynamic> get toJson {
    return {
      'authorizationUrl': '$authorizationUrl',
      'tokenUrl': '$tokenUrl',
      'refreshUrl': '$refreshUrl',
      'scopes': scopes
    };
  }
}

class OpenApiAuthScheme {
  static const Basic = 'Basic';
  static const Bearer = 'Bearer';
  static const Digest = 'Digest';
  static const HOBA = 'HOBA';
  static const Mutual = 'Mutual';
  static const Negotiate = 'Negotiate';
  static const OAuth = 'OAuth';
  static const SCRAM_SHA_1 = 'SCRAM-SHA-1';
  static const SCRAM_SHA_256 = 'SCRAM-SHA-256';
  static const Vapid = 'vapid';
}

class OpenApiMainObj {
  final OpenApiMainPathObj path;
  final OpenApiMainComponentObj component;
  final String basePath;
  final List<String> tags;
  final OpenApiMainInfo info;
  final List<OpenApiServerObject> servers;
  final List<OpenApiSecurityRequirementObj> security;

  Map<String,dynamic> get toJson {
    var res = {
      'openapi': '3.0.0',
      'info': info.toJson,
      'basePath': basePath ?? '',
      'servers': [...servers.map<Map<String, dynamic>>((e) => e.toJson)],
    }..addEntries([
        path.toJsonEntry,
      ])..addEntries([
        component.toJsonEntry,]);

    if (security.isNotEmptyObj) {
      res.addEntries([MapEntry('security', security.map((e) => e.toJson))]);
    }
    print(res);
    
    return res;
  }

  OpenApiMainObj(
      {@required this.path,
      this.security,
      this.component,
      this.basePath,
      this.tags,
      @required this.info,
      @required this.servers});
}

class OpenApiMainPathObj {
  final List<OpenApiPath> paths;
  Map get _toJson {
    return {}..addEntries(paths.map((e) => e.toJsonEntry));
  }

  OpenApiMainPathObj({this.paths});

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry('paths', _toJson);
  }
}

class OpenApiMainComponentObj {
  final List<OpenApiSchemaObj> schemas;
  final List<OpenApiSchemeProp> securitySchemes;
  Map get _toJson {
    var schemas = {};
    schemas.addEntries(this.schemas.map((e) => e.toJsonEntry));
    var securitySchemes = {};
    securitySchemes.addEntries(this.securitySchemes.map((e) => e.toJsonEntry));

    var res = {'schemas': schemas, 'securitySchemes': securitySchemes};

    return res;
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry('components', _toJson);
  }

  OpenApiMainComponentObj({this.schemas, this.securitySchemes});
}

class OpenApiSchemeProp {
  final String name;
  final String type;
  final String scheme;
  OpenApiSchemeProp({this.type, this.name, this.scheme});

  Map get _toJson {
    return {'type': type, 'scheme': scheme};
  }

  MapEntry<String, dynamic> get toJsonEntry {
    return MapEntry(name, _toJson);
  }
}

class OpenApiSchemaObj {
  final List<OpenApiProp> properties;
  final String title;
  final List<String> requiredfields;
  final Type type;

  Map<String, dynamic> get _toJson {
    var properties = <String, dynamic>{}
      ..addEntries(this.properties.map<MapEntry<String, dynamic>>((e) => e.toJsonEntry));
    var res = {'properties': properties, 'title': title, 'type': 'object'};
    return res;
  }

  MapEntry<String, Map<String,dynamic>> get toJsonEntry {
    return MapEntry(title.capitalizeFirstLetter, _toJson);
  }

  OpenApiSchemaObj(
      {this.properties, this.title, this.requiredfields, this.type});
}
