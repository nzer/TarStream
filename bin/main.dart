import 'dart:io';

import 'package:tar_stream/src/TarStream.dart';

void main(List<String> arguments) async {
  final file = File('7z.tar');
  final fileStream = file.openRead();
  final tarStream = TarStream.fromStream(fileStream);
  await for (var item in tarStream) {
    print(item.Name);
    print(item.Length);
  }
}
