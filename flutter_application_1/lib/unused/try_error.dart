import 'dart:io';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';

void main() => tryError();

Future<void> tryError () async {
  Directory directory = await getApplicationDocumentsDirectory();
  sleep(Duration(seconds: 2));
  String dirPath = '${directory.path}helo.txt';
  log(dirPath);
  log("Hellowolrd");
}
