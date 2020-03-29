class TarFile {
  String Name;
  int Length;
  /// Must be closed before reading next TarFile
  Stream<List<int>> contentStream;
}