# example_server

This is a very basic example of a REST server, to be used in a tutorial
for writing DSA DSLinks. (Link to tutorial to follow). While the example,
and tutorial for the DSLink, are written using [Dart](https://dartlang.org),
it is beyond the scope of this demo and the tutorial to teach the
[Dart Programming language](https://dartlang.org/guides/language/language-tour).

## Installation

Clone the project with:

```
git clone https://github.com/butlermatt/example_server.git
```

From there, change into the directory and run:

```
pub get
```

_(Note: the pubspec.lock has been provided to keep packages on the same version
as when developed.)_

## Run

The server can be started with the following command:

```
pub run example_server
```

If you wish you specify a port different from the default (`8001`), use the
`--port` or `-p` argument. For example:

```
pub run example_server --port 9001
```

You can then test the server by accessing the site listed in the console, in 
your web browser. For example open `http://localhost:8001/users`.

## API

Currently there is only a very simple interface which has been implemented for
this server. All paths provided are relative the server address listed above.

### Users

#### User Object

```json
{
  "id": 0,
  "admin": false,
  "firstName": "John",
  "lastName": "Doe",
  "email": "email@address.com",
  "birthday": "1980-07-13",
  "location": {
    "address": "123 Fake Street",
    "city": "Fake Town",
    "state": "NJ",
    "country": "USA"
  }
}
```

Value name | Value Type
---------- | ----------
`id` | Integer
`admin` | Boolean
`firstName` | String
`lastName` | String
`email` | String
`birthday` | String (YYYY-MM-DD format)
`location` | Object
`address` | String
`city` | String
`state` | String
`country` | String

#### List all users

Path to list all users is `/users`, via a `GET` request. Returns with an HTTP
OK status code (200) and a list of [User Objects](#user-object)

Example request:

```
curl http://localhost:8001/users
```

Response:

```
[{"id":1,"admin":false,"firstName":"John Jacob",
"lastName":"Jingleheimer Schmidt","email":"jjj@schmidt.com",
"birthday":"1931-04-01","location":{"address":"310 E Church St","city":"Elmira",
"state":"NY","country":"USA"}},{"id":2,"admin":false,"firstName":"John",
"lastName":"Doe","email":"jd@fake.com","birthday":"1976-08-10",
"location":{"address":"42 Fake Street","city":"Fake Town","state":"WY",
"country":"USA"}},{"id":3,"admin":false,"firstName":"John Jr.","lastName":"Doe",
"email":"junior@fake.com","birthday":"1990-10-08","
location":{"address":"42 Fake Street","city":"Fake Town","state":"WY",
"country":"USA"}}]
```

#### Add a new user

Path to add a user is `/users`, via a `POST` request with a content type of
`Content-Type: application/json`. The body of the request
should be a `JSON` object of the [User Object](#user-object). The `id` field
of the User object must be null or absent.

Request will return with an HTTP OK status code (200) and the complete 
User Object, including the new `id`. If an error occurs, it will return an 
HTTP Bad Request (400) error code.

Example Request:

```
curl -H "Content-Type: application/json" -X POST -d '{"id":null,"admin":false,"firstName":"Test","lastName":"Test","email":"notvalid@email.com","birthday":"1981-07-13","location":{"address":"456 My Street","city":"Halifax","state":"NS","country":"Canada"}}' http://localhost:8001/users
```

Response:

```
{"id":4,"admin":false,"firstName":"Test","lastName":"Test","email":"notvalid@email.com","birthday":"1981-07-13","location":{"address":"456 My Street","city":"Halifax","state":"NS","country":"Canada"}}
```

#### Retrieve single user
 
Path to retrieve a single user by their User ID is `/users/{userId}` via a
`GET` request. The `userId` should be an integer. If there is an error with
the `userId` the request will return HTTP Bad Request (400) status code. If
the specified `userId` is valid but cannot be found, then it will return with
Http Not Found (404) status code. On success the request will return with
Http OK (200) and a body of the JSON User Object.

Example Request:

```
curl http://localhost:8001/users/2 
```

Example Response:

```
{"id":2,"admin":false,"firstName":"John","lastName":"Doe","email":"jd@fake.com","birthday":"1976-08-10","location":{"address":"42 Fake Street","city":"Fake Town","state":"WY","country":"USA"}}
```

#### Update a user

To update a User, send a `PUT` request with the full user object JSON to
`/users/{userId}`. The `userId` must also match the User ID of the User object
or the request will return with an Http Bad Request (400) status. The request
will return Http Bad Request (400) status on failure and Http OK (200) status,
with the updated User object json in the body, on success. 

Example Request:

```
curl -H "Content-Type: application/json" -X PUT -d '{"id":2,"admin":true,"firstName":"John","lastName":"Doe","email":"newEmail@fake.com","birthday":"1976-08-10","location":{"address":"42 Fake Street","city":"Fake Town","state":"WY","country":"USA"}}' http://localhost:8001/users/2
```

Example Response:

```
{"id":2,"admin":true,"firstName":"John","lastName":"Doe","email":"newEmail@fake.com","birthday":"1976-08-10","location":{"address":"42 Fake Street","city":"Fake Town","state":"WY","country":"USA"}}
```

#### Delete a user

To remove a user, send a `DELETE` request to `/users/{userId}`. Request will
return with Http Bad Request (400) status on invalid User ID. It will return 
Http Not Found (404) status if the user ID is valid but not found. Otherwise
it will return with Http OK (200) status.

Example Request:

```
curl -X DELETE http://localhost:8001/users/1
```

There is no output to show from the response.
