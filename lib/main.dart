// import 'dart:convert';
// import 'package:azuretest/userModel.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:app_links/app_links.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Uri? _receivedUri;
//   String? _accessToken;
//   String userName = '';
//   String userUniqueName = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initAppLinks();
//   }
//
//   Future<void> _initAppLinks() async {
//     final appLinks = AppLinks();
//
//     appLinks.uriLinkStream.listen((Uri uri) {
//       setState(() {
//         _receivedUri = uri;
//         _accessToken = _extractAccessToken(uri);
//         convertToken(_accessToken!);
//       });
//     });
//
//     final initialUri = await appLinks.getInitialLink();
//     if (initialUri != null) {
//       setState(() {
//         _receivedUri = initialUri;
//         _accessToken = _extractAccessToken(initialUri);
//       });
//     }
//   }
//
//   String? _extractAccessToken(Uri uri) {
//     return uri.queryParameters['access_token'];
//   }
//
//   Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri)) {
//       throw 'Could not launch $url';
//     }
//   }
//
//   void convertToken(String token) {
//     List<String> tokenParts = token.split('.');
//     if (tokenParts.length != 3) {
//       print('Invalid token format');
//       return;
//     }
//
//     String decodedPayload;
//     try {
//       decodedPayload = utf8.decode(base64Url.decode(base64.normalize(tokenParts[1])));
//     } catch (e) {
//       print('Error decoding payload: $e');
//       return;
//     }
//
//     Map<String, dynamic> tokenJson;
//     try {
//       tokenJson = jsonDecode(decodedPayload);
//     } catch (e) {
//       print('Error decoding JSON: $e');
//       return;
//     }
//
//     setState(() {
//       UserModel user = UserModel.fromJson(tokenJson);
//       userName = user.name ?? '';
//       userUniqueName = user.uniqueName ?? '';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('URI Handling Example'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () => _launchUrl(
//                     'https://login.microsoftonline.com/1da37d04-1a21-4aef-a243-0eb986177bf3/oauth2/v2.0/authorize?response_type=code&client_id=9a630d5c-9a0e-472b-8033-3628818669ca&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fcallback&scope=openid'
//                 ),
//                 child: const Text('Launch URL'),
//               ),
//               if (_receivedUri != null)
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text('Welcome $userName : $userUniqueName'),
//                       Text('Access Token: $_accessToken'),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppLinks _appLinks = AppLinks();
  Stream<String?>? _linkStream;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    // Handle the initial link when the app is launched
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink as String);
    }

    // Listen to the stream for new links while the app is in the foreground
    _linkStream = _appLinks.uriLinkStream as Stream<String?>?;
    _linkStream?.listen((String? link) {
      if (link != null) {
        _handleLink(link);
      }
    });
  }

  void _handleLink(String link) {
    final uri = Uri.parse(link);
    final accessToken = uri.queryParameters['access_token'];
    // Handle the access token as needed
    print('Received access token: $accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Handling'),
      ),
      body: const Center(
        child: Text('Waiting for deep link...'),
      ),
    );
  }
}