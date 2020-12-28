import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:maintenance_man_v2/custom_components/custom_color_theme.dart';
import 'package:package_info/package_info.dart';

class AppInfoScreen extends StatefulWidget {
  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  String appVersion;
  String buildNumber;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColorTheme.selectionScreenBackground,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              Icons.close,
              color: CustomColorTheme.selectionScreenAccent,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ),
      ),
      body: Container(
        color: CustomColorTheme.selectionScreenBackground,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'For support, please contact: '),
                    TextSpan(
                      text: 'simpson.jacob.barry@gmail.com',
                      style: TextStyle(
                        color: CustomColorTheme.selectionScreenAccent,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final email = Email(
                            body:
                                'Application Details (please do not remove):\n\tApp Version: $appVersion\n\tBuild Number: $buildNumber',
                            subject: 'User Contact',
                            recipients: ['simpson.jacob.barry@gmail.com'],
                          );
                          await FlutterEmailSender.send(email);
                        },
                    ),
                  ],
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'App Version: $appVersion',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Development Stack:',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                '\u2022 Flutter',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '\u2022 Dart',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '\u2022 Firebase Firestore',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '\u2022 Firebase Auth',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                '\u2022 Firebase Storage',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
