import 'dart:io';

import 'package:DartTarStream/DartTarStream.dart' as DartTarStream;

void main(List<String> arguments) async {
  final file = File("C:\\Projects\\DartTarStream\\ustar.tar");
  final fileStream = file.openRead();
  final tarStream = DartTarStream.createStream(fileStream);
  final tarFile = await tarStream.single;
  print(tarFile.Name);
  print(tarFile.Length);
}
