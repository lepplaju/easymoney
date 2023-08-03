import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Prepends the application documents directory to [path]
///
/// Takes [path] which is the path you want to use inside your applications
/// document directory. This should start with '/'.
/// Returns the whole path starting with applications document directory
/// with [path] appended to it.
Future<String> getPath(String path) async {
  final wholePath = '${(await getApplicationDocumentsDirectory()).path}$path';
  if (!Directory(wholePath).existsSync()) {
    Directory(wholePath).createSync();
  }
  return wholePath;
}
