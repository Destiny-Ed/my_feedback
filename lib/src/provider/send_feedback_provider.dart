import 'package:flutter/material.dart';
import 'package:my_feedback/src/models/feedback_type.dart';

class SendFeedbackProvider extends ChangeNotifier {
  // Feedback type selected by the user
  FeedbackType? _feedbackType;
  FeedbackType? get feedbackType => _feedbackType;

  // Set feedback type and notify listeners of any changes
  void setFeedbackType(FeedbackType? type) {
    _feedbackType = type;
    notifyListeners();
  }

  // String? _apiToken;
  // String? get apiToken => _apiToken;
  // // Set api token to use for authentication
  // void setApiToken(String? token) {
  //   _apiToken = token;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     notifyListeners();
  //   });
  // }

  // User's email or ID associated with feedback
  String _userIdEmail = "";
  String get userIdEmail => _userIdEmail;
  set userIdEmail(String value) {
    if (_userIdEmail != value) {
      _userIdEmail = value;
      notifyListeners();
    }
  }

  // User's additional message associated with feedback
  String _userAdditionalMessage = "";
  String get userAdditionalMessage => _userAdditionalMessage;
  set userAdditionalMessage(String value) {
    if (_userAdditionalMessage != value) {
      _userAdditionalMessage = value;
      notifyListeners();
    }
  }

  // List of images uploaded with the feedback
  final List<UploadedMediaModel> _uploadedImages = [];
  List<UploadedMediaModel> get uploadedImages => List.unmodifiable(_uploadedImages);

  // Add an image to the uploaded images list and notify listeners
  void addImage(UploadedMediaModel image) {
    _uploadedImages.add(image);
    notifyListeners();
  }

  // Remove an image at a specific index and notify listeners
  void removeImage(int index) {
    if (index >= 0 && index < _uploadedImages.length) {
      _uploadedImages.removeAt(index);
      notifyListeners();
    }
  }

  // Clear all uploaded images and notify listeners
  void clearAll() {
    _uploadedImages.clear();
    notifyListeners();
  }
}
