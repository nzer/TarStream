import 'dart:io';

import 'package:DartTarStream/DartTarStream.dart' as DartTarStream;

void main(List<String> arguments) async {
  final arc = File("C:\\Projects\\DartTarStream\\ustar.tar");
  final sss = arc.openRead();
  final tarStream = DartTarStream.createStream(sss);
  final tf = await tarStream.single;
  print(tf.Name);
  print(tf.Length);
}
