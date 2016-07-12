// Copyright (c) 2016, Matthew Butler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert' show JSON;

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import 'package:example_server/user.dart';

void main(List<String> args) {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');

  var result = parser.parse(args);

  var port = int.parse(result['port'], onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  var md = shelf.createMiddleware(responseHandler: (shelf.Response r) {
    var headers = { 'content-type': ContentType.JSON.toString()};
    return r.change(headers: headers);
  });
  var route = router()..addAll(new UserRouter(), path: '/user');

  var handler = const shelf.Pipeline()
          .addMiddleware(md)
          .addHandler(route.handler);

  io.serve(handler, '0.0.0.0', port).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

class UserRouter {
  List<User> users;

  UserRouter() {
    users = new List<User>();
    users..add(new User(0, 'Matt', 'Butler', 'notvalid@email.com',
        new DateTime.now().subtract(new Duration(days: 1)),
        new Location('123 Some street', 'Springfield', '??', 'Canada')))
        ..add(new User(1, 'John Jacob', 'Jingleheimer Schmidt', 'jjj@schmidt.com',
            DateTime.parse('1931-04-01'),
            new Location('310 E Church St', 'Elmira', 'NY', 'USA')));
  }

  call(Router r) =>
    r..get('list', list)
        ..get('{userId}', getUser);

  shelf.Response list(shelf.Request req) {
    var list = JSON.encode(users);
    // Handle query parameters
//    var query = req.url.queryParameters;
//    print('query: $query');

    return new shelf.Response.ok(list);
  }

  shelf.Response getUser(shelf.Request req) {
    var userId = int.parse(getPathParameter(req, 'userId'),
        onError: (_) => null);
    if (userId == null) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    var usr = users.firstWhere((u) => u.id == userId, orElse: () => null);
    if (usr == null) {
      return new shelf.Response.notFound(null);
    }
    return new shelf.Response.ok(JSON.encode(usr));
  }
}