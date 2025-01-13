import 'package:flutter/material.dart';

class FeedbackModel {
  final String title;
  final String description;
  final IconData icon;
  final FeedbackType type;

  FeedbackModel({required this.type, required this.title, required this.description, required this.icon});
}

enum FeedbackType { bug, improvement }

final List<FeedbackModel> needHelpData = [
  FeedbackModel(
    title: "Report a Bug",
    type: FeedbackType.bug,
    description: "Is something in the app malfunctioning or not working as expected?",
    icon: Icons.bug_report,
  ),
  FeedbackModel(
    title: "Suggest an Improvement",
    type: FeedbackType.improvement,
    description: "Do you have new ideas or suggestions to enhance this app?",
    icon: Icons.voice_chat_sharp,
  ),
];

class FeedbackActionModel {
  final String title;
  final IconData icon;
  final FeedbackActionType type;

  FeedbackActionModel({required this.type, required this.title, required this.icon});
}

enum FeedbackActionType { screenshot, recording, file, none }

final List<FeedbackActionModel> suggestionActions = [
  FeedbackActionModel(title: "Take Screenshot", type: FeedbackActionType.screenshot, icon: Icons.camera),
  FeedbackActionModel(title: "Record Screen", type: FeedbackActionType.recording, icon: Icons.video_collection_rounded),
  FeedbackActionModel(title: "Select Gallery Image", type: FeedbackActionType.file, icon: Icons.photo_library_rounded),
];

class UploadedMediaModel {
  final dynamic mediaPath; //string or UInt8List
  final MediaType mediaType; //.mp4 and png
  UploadedMediaModel({required this.mediaPath, required this.mediaType});
}

// String to64String(Uint8List value) {
//   return base64Encode(value);
// }

// Uint8List toUint8List(String value) {
//   return base64Decode(value);
// }

enum MediaType { screenshot, image, video }

class FeedbackMediaResultModel {
  final String emailId;
  final String message;
  final FeedbackType feedbackType;
  final List<Media> media;

  FeedbackMediaResultModel({
    required this.emailId,
    required this.message,
    required this.feedbackType,
    required this.media,
  });

  factory FeedbackMediaResultModel.fromJson(Map<String, dynamic> json) => FeedbackMediaResultModel(
        emailId: json["email_id"],
        message: json["message"],
        feedbackType: json["feedback_type"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "email_id": emailId,
        "message": message,
        "feedback_type": feedbackType.name,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
      };
}

class Media {
  final String type;
  final dynamic url;

  Media({
    required this.type,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
      };
}
