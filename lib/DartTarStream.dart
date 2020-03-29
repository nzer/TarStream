import 'package:chunked_stream/chunked_stream.dart';

import 'TarFile.dart';

Stream<TarFile> createStream(Stream<List<int>> stream) async* {
  final reader = ChunkedStreamIterator(stream);
  var empty_records = 0;
  while (true) {
    final headerBytes = await reader.read(512);
    if (_isRecordEmpty(headerBytes) && headerBytes.isNotEmpty) {
      empty_records++;
      continue;
    }
    if (empty_records == 2) {
      break;
    }
    if (headerBytes.length != 512) {
      throw Exception('Invalid record length');
    }
    var file = _createFile(headerBytes);
    yield file;
    //skip bytes
    final content_records = (file.Length / 512).ceil();
    if (content_records != 0) {
      await reader.read(content_records * 512);
    }
  }
}

TarFile _createFile(List<int> bytes) {
  if (bytes.length != 512) {
    throw Exception('Invalid header record length');
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

bool _isRecordEmpty(List<int> record) {
  for (var byte in record) {
    if (byte != 0) return false;
  }
  return true;
}
