import 'dart:io';
import 'package:dio/dio.dart';

Future<List<MultipartFile>> prepareDocuments(List<File> files) async {
  List<MultipartFile> multipartList = [];

  for (File file in files) {
    multipartList.add(
      await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    );
  }

  return multipartList;
}
