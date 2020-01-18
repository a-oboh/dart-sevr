// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library http_server.http_body_impl;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sevr/src/mime/mime.dart';

import 'http_body.dart';
import 'http_multipart_form_data.dart';

class HttpBodyHandlerTransformer
    extends StreamTransformerBase<HttpRequest, HttpRequestBody> {
  final Encoding _defaultEncoding;

  const HttpBodyHandlerTransformer(this._defaultEncoding);

  @override
  Stream<HttpRequestBody> bind(Stream<HttpRequest> stream) {
    return Stream<HttpRequestBody>.eventTransformed(
        stream,
        (EventSink<HttpRequestBody> sink) =>
            _HttpBodyHandlerTransformerSink(_defaultEncoding, sink));
  }
}

class _HttpBodyHandlerTransformerSink implements EventSink<HttpRequest> {
  final Encoding _defaultEncoding;
  final EventSink<HttpRequestBody> _outSink;
  int _pending = 0;
  bool _closed = false;

  _HttpBodyHandlerTransformerSink(this._defaultEncoding, this._outSink);

  @override
  void add(HttpRequest request) {
    _pending++;
    HttpBodyHandlerImpl.processRequest(request, _defaultEncoding)
        .then(_outSink.add, onError: _outSink.addError)
        .whenComplete(() {
      _pending--;
      if (_closed && _pending == 0) _outSink.close();
    });
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _outSink.addError(error, stackTrace);
  }

  @override
  void close() {
    _closed = true;
    if (_pending == 0) _outSink.close();
  }
}

class HttpBodyHandlerImpl {
  static Future<HttpRequestBody> processRequest(
      HttpRequest request, Encoding defaultEncoding) {
    return process(request, request.headers, defaultEncoding)
        .then((body) => _HttpRequestBody(request, body), onError: (error) {
      // Try to send BAD_REQUEST response.
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      throw error;
    });
  }

  static Future<HttpClientResponseBody> processResponse(
      HttpClientResponse response, Encoding defaultEncoding) {
    return process(response, response.headers, defaultEncoding)
        .then((body) => _HttpClientResponseBody(response, body));
  }

  static Future<HttpBody> process(
      Stream<List<int>> stream, HttpHeaders headers, Encoding defaultEncoding) {
    var contentType = headers.contentType;

    Future<HttpBody> asBinary() {
      return stream
          .fold(BytesBuilder(), (builder, data) => builder..add(data))
          .then((builder) => _HttpBody('binary', builder.takeBytes()));
    }

    Future<HttpBody> asText(Encoding defaultEncoding) {
      Encoding encoding;
      var charset = contentType.charset;
      if (charset != null) encoding = Encoding.getByName(charset);
      encoding ??= defaultEncoding;
      return encoding.decoder
          .bind(stream)
          .fold(StringBuffer(), (buffer, data) => buffer..write(data))
          .then((buffer) => _HttpBody('text', buffer.toString()));
    }

    Future<HttpBody> asFormData() {
      return MimeMultipartTransformer(contentType.parameters['boundary'])
          .bind(stream)
          .map((part) => HttpMultipartFormData.parse(part,
              defaultEncoding: defaultEncoding))
          .map((multipart) {
            Future future;
            if (multipart.isText) {
              future = multipart
                  .fold(StringBuffer(), (b, s) => b..write(s))
                  .then((b) => b.toString());
            } else {
              future = multipart
                  .fold(BytesBuilder(), (b, d) => b..add(d))
                  .then((b) => b.takeBytes());
            }
            return future.then((data) {
              var filename =
                  multipart.contentDisposition.parameters['filename'];
              if (filename != null) {
                data =
                    _HttpBodyFileUpload(multipart.contentType, filename, data);
              }
              return [multipart.contentDisposition.parameters['name'], data];
            });
          })
          .fold(<Future>[], (List<Future> l, f) => l..add(f))
          .then((values) => Future.wait(values))
          .then((parts) {
            var map = <String, dynamic>{};
            for (var part in parts) {
              map[part[0] as String] = part[1]; // Override existing entries.
            }
            return _HttpBody('form', map);
          });
    }

    if (contentType == null) {
      return asBinary();
    }

    switch (contentType.primaryType) {
      case 'text':
        return asText(defaultEncoding);

      case 'application':
        switch (contentType.subType) {
          case 'json':
            return asText(utf8)
                .then((body) => _HttpBody('json', jsonDecode(body.body)));

          case 'x-www-form-urlencoded':
            return asText(ascii).then((body) {
              var map =
                  Uri.splitQueryString(body.body, encoding: defaultEncoding);
              var result = {};
              for (var key in map.keys) {
                result[key] = map[key];
              }
              return _HttpBody('form', result);
            });

          default:
            break;
        }
        break;

      case 'multipart':
        switch (contentType.subType) {
          case 'form-data':
            return asFormData();

          default:
            break;
        }
        break;

      default:
        break;
    }

    return asBinary();
  }
}

class _HttpBodyFileUpload implements HttpBodyFileUpload {
  @override
  final ContentType contentType;
  @override
  final String filename;
  @override
  final dynamic content;
  _HttpBodyFileUpload(this.contentType, this.filename, this.content);
}

class _HttpBody implements HttpBody {
  @override
  final String type;
  @override
  final dynamic body;

  _HttpBody(this.type, this.body);
}

class _HttpRequestBody extends _HttpBody implements HttpRequestBody {
  @override
  final HttpRequest request;

  _HttpRequestBody(this.request, HttpBody body) : super(body.type, body.body);
}

class _HttpClientResponseBody extends _HttpBody
    implements HttpClientResponseBody {
  final HttpClientResponse response;

  _HttpClientResponseBody(this.response, HttpBody body)
      : super(body.type, body.body);
}
