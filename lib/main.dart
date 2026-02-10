import 'dart:io';

void main() {
  User? user = getUser();
  if (user != null) {
    print(user.gender);
  }
  if (user != null) {
    print(user.role);
  }
  Item? item = getItem();
  if (item != null) {
    print(item.id);
  }
  if (item != null) {
    print(item.id);
  }
}

class User {
  String gender;
  String role;
  User(this.gender, this.role);
}

class Item {
  String id;
  Item(this.id);
}

User? getUser() => null;

Item? getItem() => null;