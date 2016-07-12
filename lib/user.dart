class User {
  int id;
  bool admin = false;
  String first;
  String last;
  String email;
  DateTime birthday;
  Location location;

  User(this.id, this.first, this.last, this.email, this.birthday, this.location);
  User.fromJson(Map m) {
    id = m['id'];
    admin = m['admin'];
    first = m['firstName'];
    last = m['lastName'];
    email = m['email'];
    birthday = DateTime.parse(m['birthday']);
    location = new Location.fromJson(m['location']);
  }

  Map<String, dynamic> toJson() => <String, dynamic> {
    'id': id,
    'admin': admin,
    'firstName': first,
    'lastName': last,
    'email': email,
    'birthday': '${birthday.year}-' +
        '${birthday.month.toString().padLeft(2, '0')}-'
            '${birthday.day.toString().padLeft(2, '0')}',
    'location': location.toJson()
  };
}

class Location {
  String address;
  String city;
  String state;
  String country;

  Location(this.address, this.city, this.state, this.country);
  Location.fromJson(Map m) {
    address = m['address'];
    city = m['city'];
    state = m['state'];
    country = m['country'];
  }

  Map<String, String> toJson() => <String, String> {
    'address': address,
    'city': city,
    'state': state,
    'country': country
  };
}