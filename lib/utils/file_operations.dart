import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Prepends the application documents directory to [path]
///
/// Takes [path] which is the path you want to use inside your applications
/// document directory. This should start with '/'.
/// Returns the whole path starting with applications document directory
/// with [path] appended to it.
///
/// {@category Utils}
Future<String> getPath(String path) async {
  final wholePath = '${(await getApplicationDocumentsDirectory()).path}$path';
  if (!Directory(wholePath).existsSync()) {
    Directory(wholePath).createSync();
  }
  return wholePath;
}

/// Checks if the file is of accepted type
///
/// Takes a list of [endings] that are allowed and checks if the [filename] is
/// one of those.
bool isAcceptedType(List<String> endings, String filename) {
  final ending = filename.split('.').last;
  return endings.contains(ending);
}
