import 'dart:io';

import 'package:path_provider/path_provider.dart';

String joinPath(String path1, String path2) {
  final cleanPath1 =
      path1.endsWith('/') ? path1.substring(0, path1.length - 1) : path1;
  final cleanPath2 = path2.startsWith('/') ? path2.substring(1) : path2;
  return '$cleanPath1/$cleanPath2';
}

/// Prepends the application documents directory to [path]
///
/// Takes [path] which is the path you want to use inside your applications
/// document directory.
/// Returns the whole path starting with applications document directory
/// with [path] appended to it.
///
/// {@category Utils}
Future<String> getPath(String path) async {
  final applicationDirectoryPath =
      (await getApplicationDocumentsDirectory()).path;
  final wholePath = joinPath(applicationDirectoryPath, path);
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
