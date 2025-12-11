// Stub for web platform - provides a minimal File class
class File {
  final String path;
  
  File(this.path);
  
  // Add Uri getter for compatibility
  Uri get uri => Uri.parse(path);
  
  // Add any other methods that might be needed
  Future<bool> exists() async => false;
  Future<int> length() async => 0;
}
