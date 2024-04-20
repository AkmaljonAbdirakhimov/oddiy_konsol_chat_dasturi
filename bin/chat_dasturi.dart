import 'dart:convert';
import 'dart:io';

import 'package:chat_dasturi/models/message.dart';

void main(List<String> arguments) async {
  File file = File("database/message.json");
  bool fileExists = await file.exists();
  if (!fileExists) {
    await file.create(recursive: true);
  }
  List<Message> data = [];
  stdout.write("Username kiriting: ");
  String username = stdin.readLineSync()!;

  Future<void> readMessages() async {
    String jsonData = await file.readAsString();
    if (jsonData.trim().isNotEmpty) {
      List<dynamic> mapData = jsonDecode(jsonData);
      data = mapData.map((m) => Message.fromMap(m)).toList();
    }
  }

  void sendMessage() {
    if (username != data.last.username) {
      print("${data.last.username}: ${data.last.text}");
    }
  }

  await readMessages();

  // foydalanuvchi inputlarini stream ko'rinishida olyapmiz.
  print("Xabar kiriting...");
  Stream<String> messages =
      stdin.transform(utf8.decoder).transform(LineSplitter());

  // .listen() metodi orqali har bir kirityotgan inputlarini tinglayapmiz/ko'zatyapmiz
  messages.listen((message) async {
    Message newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      text: message,
      username: username,
    );
    data.add(newMessage);

    List<Map<String, dynamic>> jsonMessages =
        data.map((d) => d.toMap()).toList();

    await file.writeAsString(jsonEncode(jsonMessages));
  });

  file.watch(events: FileSystemEvent.modify).listen((event) async {
    await readMessages();
    sendMessage();
  });
}
