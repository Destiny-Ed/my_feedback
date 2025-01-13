import 'package:image_picker/image_picker.dart';

Future<String?> pickImage() async {
  final result = await ImagePicker().pickImage(
    imageQuality: 70,
    maxWidth: 1440,
    source: ImageSource.gallery,
  );

  return result?.path;
}
