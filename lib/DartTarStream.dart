import 'dart:io';
import 'dart:typed_data';

import 'package:DartTarStream/StreamReader.dart';

import 'TarFile.dart';

Stream<TarFile> createStream(Stream<List<int>> stream) async* {
  final reader = StreamReader(stream);
  final headerBytes = await reader.ReadBytes(512);
  var file = _parseHeader(headerBytes);
  yield file;
}

TarFile _parseHeader(Uint8List bytes) {
  if (bytes.lengthInBytes != 512) {
    // throw error
  }
  /*  File Header (512 bytes)
   *  Offset Size Field
   *      Pre-POSIX Header
   *  0      100  File name
   *  100    8    File mode
   *  108    8    Owner's numeric user ID
   *  116    8    Group's numeric user ID
   *  124    12   File size in bytes (as octal number in ASCII)
   *  136    12   Last modification time in numeric Unix time format (octal)
   *  148    8    Checksum for header record
   *  156    1    Type flag
   *  157    100  Name of linked file
   *      UStar Format
   *  257    6    UStar indicator "ustar"
   *  263    2    UStar version "00"
   *  265    32   Owner user name
   *  297    32   Owner group name
   *  329    8    Device major number
   *  337    8    Device minor number
   *  345    155  Filename prefix
   */
  var f = TarFile();

  var nameBytes = bytes.sublist(0, 100);
  f.Name = String.fromCharCodes(nameBytes).trim();

  var lenBytes = bytes.sublist(124, 124 + 12 - 1);
  var lenString = String.fromCharCodes(lenBytes).trim();
  f.Length = int.parse(lenString, radix: 8);
  return f;
}
