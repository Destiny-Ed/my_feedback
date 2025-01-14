# my-feedback

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Getting Started](#getting-started)
5. [Usage](#usage)
6. [Example](#example)
7. [FAQ](#faq)
8. [Contributing](#contributing)
9. [License](#license)

---

## Overview
**my-feedback** is a Flutter plugin that helps developers collect user feedback seamlessly. With features like screen recording, screenshot annotation, and gallery uploads, this plugin simplifies the process of identifying bugs and gathering user suggestions.

---

## Features
- **Screen Recording:** Record the current app screen and attach it to feedback reports.
- **Screenshot Annotation:** Capture and annotate screenshots directly within the app.
- **Gallery Upload:** Upload images from the user's device gallery.

---

## Installation
Add the plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  my_feedback: ^1.0.0
```

Fetch the plugin by running:

"flutter pub get"

---

## Installation

## Android Configuration

1.	Add the following permissions to your AndroidManifest.xml file:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

2.	Ensure your app targets API level 21 or higher.

3.	To your Android Manifest, under the <application> tag, add the following:

```xml
<service
    android:name="com.foregroundservice.ForegroundService"
    android:foregroundServiceType="mediaProjection">
</service>
```



## iOS Configuration

1.	Add the required permissions to your Info.plist file:

```plist
<key>NSMicrophoneUsageDescription</key>
<string>This app requires access to the microphone for recording feedback.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library for uploading images.</string>
```

## Usage

Wrap Your Material or Cupertino App With MyFeedBack:

```dart
    class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MyFeedback(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        );
    }
    }
```

// Start feedback and receive result

```dart
 MyFeedbackCaller.showFeedbackModalWithResult(context, userId: "user_identifier@gmail.com", onResult: (value) {
            log("Data available ${value?.toJson()}");
          });

```
        

// Feedback result with return types

[screenshot] type : uInt8List byte
[video] type : mp4 string path
[image] type : jpg string path

```json
{email_id: talk2destinyed@gmail.com, message: hello, feedback_type: bug, media: [{type: screenshot, url: [137, 80, 78, 71, 13, 10, 26]}, {type: video, url: /storage/emulated/0/Android/data/com.example.app/cache/my_feedback_record_234.mp4}, {type: image, url: /data/user/0/com.example.app/cache/scaled_pq1hw8.jpg}]}
```

## Example

```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_feedback/my_feedback.dart';
import 'package:my_feedback/provider/feedback_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFeedback(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Text("Increment counter"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //send app feedback
          MyFeedbackCaller.showFeedbackModalWithResult(context, userId: "talk2destinyed@gmail.com", onResult: (value) {
            log("Data available ${value?.toJson()}");
          });
        },
        tooltip: 'send feedback',
        child: const Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

```

How it works

![alt text](https://github.com/Destiny-Ed/flutter_ripple/blob/main/assets/ripple.gif)


## FAQ

Q: Is screen recording supported on all platforms?
A: Currently, screen recording is supported on Android and iOS.

Q: Can I customize the feedback UI?
A: No, we are currently working on customization support to fit the app branding.

## Contributing

Contributions are welcome! Please follow these steps:
    1.	Fork the repository.
    2.	Create a new branch for your feature or bugfix.
    3.	Submit a pull request with a detailed description of your changes.

Refer to the CONTRIBUTING.md file for more details.

## License

This project is licensed under the MIT License.

