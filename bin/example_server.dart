// Copyright (c) 2016, Matthew Butler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import 'package:example_server/user_router.dart';

void main(List<String> args) {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8001');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  var md = shelf.createMiddleware(responseHandler: (shelf.Response r) {
    var headers = { 'content-type': ContentType.JSON.toString()};
    return r.change(headers: headers);
  });
  var route = router()..addAll(new UserRouter(), path: '/users');

  var handler = const shelf.Pipeline()
          .addMiddleware(md)
          .addHandler(route.handler);

  io.serve(handler, '0.0.0.0', port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
