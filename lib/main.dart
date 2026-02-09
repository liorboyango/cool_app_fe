void main() {
  User? user = User();
  print(user?.gender); // line 116
  print(user?.role); // line 117
  Obj? obj = Obj();
  print(obj?.id); // line 183
  print(obj?.id); // line 202
}

class User {
  String? gender;
  String? role;
}

class Obj {
  int? id;
}