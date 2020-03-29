import 'dart:io';

import 'package:DartTarStream/DartTarStream.dart' as DartTarStream;
import 'package:test/test.dart';

void main() {
  test('ustar_longname', () async {
    await testTar('ustar.tar');
  });
  test('python_testtar', () async {
    await testTar('testtar.tar');
  });
  test('7z_tar', () async {
    await testTar('7z.tar');
  });
}

void testTar(String filename) async {
  final file = File(filename);
  final fileStream = file.openRead();
  final tarStream = DartTarStream.createStream(fileStream);
  await for (var item in tarStream) {
    print(item.Name);
    print(item.Length);
  }
}
