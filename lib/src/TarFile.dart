part of 'TarStream.dart';
class TarFile {
  String Name;
  int Length;
  Stream<List<int>> _contentStream;
  bool _contentStreamAcquired = false;

  /// Must be closed before reading next TarFile
  Stream<List<int>> get contentStream  {
    _contentStreamAcquired = true;
    return _contentStream;
  }
}