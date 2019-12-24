// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Here is a short example of how to serve all files from the current
/// directory.
///
/// 	import 'dart:io';
/// 	import 'dart:async';
/// 	import 'package:http_server/http_server.dart';
///
/// 	void main() {
/// 	  var staticFiles = new VirtualDirectory('.')
/// 	    ..allowDirectoryListing = true;
///
/// 	  runZoned(() {
/// 	    HttpServer.bind('0.0.0.0', 7777).then((server) {
/// 	      print('Server running');
/// 	      server.listen(staticFiles.serveRequest);
/// 	    });
/// 	  },
/// 	  onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
///     }
///
/// ## Virtual directory
///
/// The [VirtualDirectory] class makes it easy to serve static content
/// from the file system. It supports:
///
///  *  Range-based requests.
///  *  If-Modified-Since based caching.
///  *  Automatic GZip-compression of content.
///  *  Following symlinks, either throughout the system or inside
///     a jailed root.
///  *  Directory listing.
///
/// See [VirtualDirectory] for more information.
///
/// ## Virtual host
///
/// The [VirtualHost] class helps to serve multiple hosts on the same
/// address, by using the `Host` field of the incoming requests. It also
/// works with wildcards for sub-domains.
///
///     var virtualHost = new VirtualHost(server);
///     // Filter out on a specific host
///     var stream1 = virtualServer.addHost('static.myserver.com');
///     // Wildcard for any other sub-domains.
///     var stream2 = virtualServer.addHost('*.myserver.com');
///     // Requests not matching any hosts.
///     var stream3 = virtualServer.unhandled;
///
/// See [VirtualHost] for more information.
library http_server;

import 'src/virtual_directory.dart';
import 'src/virtual_host.dart';

export 'src/http_body.dart';
export 'src/http_multipart_form_data.dart';
export 'src/virtual_directory.dart';
export 'src/virtual_host.dart';
