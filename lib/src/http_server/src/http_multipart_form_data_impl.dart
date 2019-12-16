// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library http_server.http_multipart_form_data_impl;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sevr/src/mime/mime.dart';

import 'http_multipart_form_data.dart';

class HttpMultipartFormDataImpl extends Stream
    implements HttpMultipartFormData {
  final ContentType contentType;
  final HeaderValue contentDisposition;
  final HeaderValue contentTransferEncoding;

  final MimeMultipart _mimeMultipart;

  bool _isText = false;

  Stream _stream;

  HttpMultipartFormDataImpl(
      this.contentType,
      this.contentDisposition,
      this.contentTransferEncoding,
      this._mimeMultipart,
      Encoding defaultEncoding) {
    _stream = _mimeMultipart;
    if (contentTransferEncoding != null) {
      // TODO(ajohnsen): Support BASE64, etc.
      throw HttpException("Unsupported contentTransferEncoding: "
          "${contentTransferEncoding.value}");
    }

    if (contentType == null ||
        contentType.primaryType == 'text' ||
        contentType.mimeType == 'application/json') {
      _isText = true;
      Encoding encoding;
      if (contentType != null && contentType.charset != null) {
        encoding = Encoding.getByName(contentType.charset);
      }
      encoding ??= defaultEncoding;
      _stream = _stream.transform(encoding.decoder);
    }
  }

  bool get isText => _isText;
  bool get isBinary => !_isText;

  static HttpMultipartFormData parse(
      MimeMultipart multipart, Encoding defaultEncoding) {
    ContentType type;
    HeaderValue encoding;
    HeaderValue disposition;
    var remaining = <String, String>{};
    for (var key in multipart.headers.keys) {
      switch (key) {
        case 'content-type':
          type = ContentType.parse(multipart.headers[key]);
          break;

        case 'content-transfer-encoding':
          encoding = HeaderValue.parse(multipart.headers[key]);
          break;

        case 'content-disposition':
          disposition = HeaderValue.parse(multipart.headers[key],
              preserveBackslash: true);
          break;

        default:
          remaining[key] = multipart.headers[key];
          break;
      }
    }
    if (disposition == null) {
      throw const HttpException(
          "Mime Multipart doesn't contain a Content-Disposition header value");
    }
    return HttpMultipartFormDataImpl(
        type, disposition, encoding, multipart, defaultEncoding);
  }

  StreamSubscription listen(void onData(data),
      {void onDone(), Function onError, bool cancelOnError}) {
    return _stream.listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  }

  String value(String name) {
    return _mimeMultipart.headers[name];
  }
}
