import 'dart:io';

import 'package:DartTarStream/DartTarStream.dart' as DartTarStream;

void main(List<String> arguments) async {
  final file = File('7z.tar');
  final fileStream = file.openRead();
  final tarStream = DartTarStream.createStream(fileStream);
  await for (var item in tarStream) {
    print(item.Name);
    print(item.Length);
  }
}
