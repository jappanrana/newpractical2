class User {
  late String id;
  late String name;
  late String image;

  User({
    this.id = "",
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
    'image':image,
  };

  static User fromJson(Map<String,dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    image: json['image'],
  );
}