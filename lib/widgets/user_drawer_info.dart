import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:maintenance_man_v2/providers/auth.dart';
import 'package:maintenance_man_v2/widgets/add_image_dialog.dart';
import 'package:provider/provider.dart';

class UserDrawerInfo extends StatefulWidget {
  @override
  _UserDrawerInfoState createState() => _UserDrawerInfoState();
}

class _UserDrawerInfoState extends State<UserDrawerInfo> {
  final _picker = ImagePicker();
  var _isLoading = false;
  String _photoUrl;

  Future<String> _updateProfilePicture(ImageSource imgSrc, String uid) async {
    PickedFile image = await _picker.getImage(source: imgSrc);
    if (image == null) return null;
    var ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('profile_$uid.jpg');
    await ref.putFile(File(image.path));
    final storageUrl = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser.updateProfile(
      photoURL: storageUrl,
    );
    return storageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final cred = Provider.of<Auth>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: CustomColorTheme.selectionScreenBackground,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (_photoUrl != null || cred.userCredential.photoURL != null) {
                // Todo: allow user to view profile picture
                return;
              }
              final res = await addImageDialog(context);
              if (res == null) return;
              setState(() {
                _isLoading = true;
              });
              await _updateProfilePicture(res, cred.userCredential.uid);
              setState(() {
                _isLoading = false;
              });
            },
            child: CircleAvatar(
              radius: 50,
              child: _isLoading ? CircularProgressIndicator() : null,
              backgroundImage:
                  cred?.userCredential?.photoURL == null && _photoUrl == null
                      ? AssetImage('assets/icons/user.png')
                      : NetworkImage(_photoUrl ?? cred.userCredential.photoURL),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cred.userCredential.displayName ?? 'Display Name',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: CustomColorTheme.selectionScreenAccent,
                    fontSize: 15,
                  ),
                ),
                Text(
                  cred.userCredential.email,
                  style: TextStyle(color: Colors.white),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Column(
                //       children: [
                //         Icon(Icons.car_repair),
                //         Text('0'),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Icon(Icons.home_work),
                //         Text('0'),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
