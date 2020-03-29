import 'dart:io';

import 'dart:typed_data';

class StreamReader {
  Stream<List<int>> _stream;
  List<int> _currentBuffer;
  int _currentPosition = 0;
  int _currentBufferPosition = 0;

  StreamReader(Stream<List<int>> stream) {
    _stream = stream;
  }

  Future<int> ReadByte() async {
    _currentPosition++;
    _currentBufferPosition++;
    await _ensureBufferValid();
    final byte = _currentBuffer[_currentBufferPosition];
    return byte;
  }

  Future<Uint8List> ReadBytes(int n) async {
    var builder = BytesBuilder();
    var bytesRead = 0;
    while (bytesRead != n) {
      final byte = ReadByte();
      builder.addByte(await byte);
      bytesRead++;
    }
    return builder.toBytes();
  }

  void _ensureBufferValid() async {
    //Buffer is over or null
    if (_currentBuffer == null ||
        _currentBufferPosition >= _currentBuffer.length) {
      _currentBuffer = await _stream.single;
      _currentBufferPosition = 0;
    }
    //Stream is over
  }
}
