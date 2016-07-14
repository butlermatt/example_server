import 'dart:io';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_route/shelf_route.dart';

import 'user.dart';

class UserRouter {
  List<User> users;

  UserRouter() {
    users = new List<User>();
    users..add(new User(0, 'Matt', 'Butler', 'notvalid@email.com',
        new DateTime.now().subtract(new Duration(days: 1)),
        new Location('123 Some street', 'Springfield', '??', 'Canada')))
      ..add(new User(1, 'John Jacob', 'Jingleheimer Schmidt', 'jjj@schmidt.com',
          DateTime.parse('1931-04-01'),
          new Location('310 E Church St', 'Elmira', 'NY', 'USA')))
      ..add(new User(2, 'John', 'Doe', 'jd@fake.com',
          DateTime.parse('1976-08-10'),
          new Location('42 Fake Street', 'Fake Town', 'WY', 'USA')))
      ..add(new User(3, 'John Jr.', 'Doe', 'junior@fake.com',
          DateTime.parse('1990-10-08'),
          new Location('42 Fake Street', 'Fake Town', 'WY', 'USA')));
  }

  call(Router r) => r..get('', list)
    ..post('', addUser)
    ..get('{userId}', getUser)
    ..put('{userId}', updateUser);

  /// Path: GET - /users{?...} provides a list of users in the system.
  /// Returns a list of users, optionally filtered by query parameters.
  shelf.Response list(shelf.Request req) {
    // Handle query parameters
//    var query = req.url.queryParameters;
//    print('query: $query');

    var list = JSON.encode(users);
    return new shelf.Response.ok(list);
  }

  /// Path: POST - /users expects to receive a JSON request body with the
  /// user to be added. Note that user.id must be null (or absent) or the
  /// request will fail with [HttpStatus.BAD_REQUEST]. Returns with
  /// [HttpStatus.BAD_REQUEST] on failure or [HttpStatus.OK] and the full
  /// JSON user object on success.
  Future<shelf.Response> addUser(shelf.Request req) async {
    var usrStr = await req.readAsString();

    Map um;
    try {
      um = JSON.decode(usrStr);
    } catch (e) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    if (um['id'] != null) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    User user;
    try {
      user = new User.fromJson(um);
      users.add(user);
    } catch (e) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    users.add(user);
    return new shelf.Response.ok(JSON.encode(user));
  }

  /// Path: GET - /users/{userId} Retrieves the specified user by ID. Returns
  /// [HttpStatus.BAD_REQUEST] for invalid ID, [HttpStatus.NOT_FOUND] for
  /// unknown user ID, otherwise returns [HttpStatus.OK] and a JSON string
  /// of the user.
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

  /// Path: PUT - /users/{userId} Updates the specified user ID with the
  /// provided user. Accepts a JSON string of the full user object to be
  /// updated. Returns [HttpStatus.BAD_REQUEST] on error and returns
  /// [HttpStatus.OK] on success.
  Future<shelf.Response> updateUser(shelf.Request req) async {
    var usrStr = await req.readAsString();
    User usr;
    int userId;
    try {
      userId = int.parse(getPathParameter(req, 'userId'));
      var map = JSON.decode(usrStr);
      usr = new User.fromJson(map);
    } catch (e) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    if (userId != usr.id) {
      return new shelf.Response(HttpStatus.BAD_REQUEST);
    }

    for (var i = 0; i < users.length; i++) {
      if (users[i].id == userId) {
        users[i] = usr;
        break;
      }
    }
    return new shelf.Response(HttpStatus.OK);
  }
}
