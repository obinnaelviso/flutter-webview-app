import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  runApp(
    const MaterialApp(
      title: "Samara",
      home: MainPage(),
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late InAppWebViewController wvController;
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await wvController.canGoBack()) {
          wvController.goBack();
          return false; // stay on app
        } else {
          return true; //  exit app
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
          title: const Text('Samara'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (await wvController.canGoBack()) {
                  wvController.goBack();
                }
              },
            ),
            IconButton(
              onPressed: () => wvController.reload(),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Column(
          children: [
            Visibility(
              visible: (progress < 1.0) ? true : false,
              child: LinearProgressIndicator(
                value: progress,
                color: Colors.red,
                backgroundColor: Colors.black12,
              ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse('http://samara.techmelon.com.my'),
                ),
                onWebViewCreated: (controller) {
                  wvController = controller;
                },
                onProgressChanged: (controller, progress) => setState(
                  () {
                    this.progress = progress / 100;
                    if (kDebugMode) {
                      print(progress);
                      print(this.progress);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
