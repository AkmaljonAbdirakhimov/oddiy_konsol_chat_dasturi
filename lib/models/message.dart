class Message {
  int id;
  String text;
  String username;

  Message({
    required this.id,
    required this.text,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": text,
      "username": username,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      username: map['username'],
    );
  }
}
