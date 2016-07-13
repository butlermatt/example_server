class User {
  static int _mId = -1;

  int id;
  bool admin = false;
  String first;
  String last;
  String email;
  DateTime birthday;
  Location location;

  User(this.id, this.first, this.last, this.email, this.birthday,
      this.location) {
    if (id == null) {
      id = ++_mId;
    } else if (id > _mId) {
      _mId = id;
    }
  }

  factory User.fromJson(Map m) {
    var usr = new User(m['id'], m['firstName'], m['lastName'],
        m['email'], DateTime.parse(m['birthday']),
        new Location.fromJson(m['location']));

    usr.admin = m['admin'];
    return usr;
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