// Conditional export for dart:io
// On web, this will not export anything (File will be unavailable)
// On mobile/desktop, this exports the real File class from dart:io

export 'universal_io_stub.dart'
    if (dart.library.io) 'dart:io' show File;

