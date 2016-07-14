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

Path to list all users is `/user`, via a `GET` request.

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
