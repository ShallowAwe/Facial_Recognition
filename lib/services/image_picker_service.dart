 import 'dart:io';


import 'package:image_picker/image_picker.dart';

class ImagePickerService {

   
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async{
    try {

      final XFile? pickedFiles = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFiles != null) {
        return File(pickedFiles.path);
      }
    } catch (e) {
      print('the erroe is as  follows : $e');
    }
    return null;
  }

   Future<File?> pickImageFromGallery() async{
    try {
      final XFile? pickedFiles = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFiles != null) {
        return File(pickedFiles.path);
      }
    } catch (e) {
      print('the erroe is as  follows : $e');
    }
    return null;
  }
   
  
    
  }

 