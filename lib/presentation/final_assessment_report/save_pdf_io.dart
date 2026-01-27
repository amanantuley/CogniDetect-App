import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> savePdfBytes(List<int> bytes, {String filename = 'report.pdf'}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsBytes(bytes);
}
