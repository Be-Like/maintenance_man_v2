import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> addImageDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Vehicle Image'),
      content: Text(
        'Would you like to take an image or choose from your gallery?',
      ),
      actions: [
        FlatButton(
          child: Text('Gallery'),
          onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
        ),
        FlatButton(
          child: Text('Camera'),
          onPressed: () => Navigator.of(context).pop(ImageSource.camera),
        ),
      ],
    ),
  );
}
