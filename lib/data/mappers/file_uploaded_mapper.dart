import 'package:teslo_app/domain/entities/file_uploaded.dart';

class FileUploadedMapper {
  static FileUploaded fileJsonToEntity(Map<String, dynamic> json) {
    return FileUploaded(image: json['image'] as String);
  }
}
