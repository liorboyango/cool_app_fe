import 'dart:convert';

void main() {
  // some code
  // assume line 116
  User? user = getUser();
  print(user?.gender);
  print(user?.role);
  // some code to reach line 183
  Obj? obj = getObj();
  var id = obj?.id;
  // some code to 202
  Another? another = getAnother();
  var id2 = another?.id;
}

class User {
  String gender;
  String role;
  User(this.gender, this.role);
}

class Obj {
  int id;
  Obj(this.id);
}

class Another {
  int id;
  Another(this.id);
}

User? getUser() => null;
Obj? getObj() => null;
Another? getAnother() => null;