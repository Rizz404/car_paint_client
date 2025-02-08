import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<File> urlToFile(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final fileName = imageUrl.split('/').last;
  final file = File('${documentDirectory.path}/$fileName');
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}
