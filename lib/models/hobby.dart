class Hobby {
  final String? name;
  final int ?id;
  final String? avatar;

  Hobby({this.name,this.id, this.avatar});

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      name: json['name'],
      id: json['id'],
      avatar: "", // You can set the avatar URL here if needed
    );
  }
}
