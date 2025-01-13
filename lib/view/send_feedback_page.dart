import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_feedback/shared/utils/gallery_picker.dart';
import 'package:my_feedback/shared/widgets/custom_text_field.dart';
import 'package:my_feedback/models/feedback_type.dart';
import 'package:my_feedback/provider/feedback_provider.dart';
import 'package:my_feedback/provider/send_feedback_provider.dart';
import 'package:provider/provider.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            _buildFeedbackForm(context),
            _buildSuggestionSheet(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final state = context.watch<SendFeedbackProvider>();
    return AppBar(
      title: Text(
        state.feedbackType == FeedbackType.improvement ? "Suggest an Improvement" : "Report Bug",
      ),
      actions: [
        GestureDetector(
          onTap: () => _handleSubmit(context, state),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Submit"),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackForm(BuildContext context) {
    final state = context.watch<SendFeedbackProvider>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: "Enter email or ID",
            initialText: state.userIdEmail,
            readOnly: true,
            onChanged: (value) => state.userIdEmail = value,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hintText: "Additional Message",
            minLines: 4,
            maxLines: 6,
            initialText: state.userAdditionalMessage,
            onChanged: (value) => state.userAdditionalMessage = value,
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildImageGallery(context, state)),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, SendFeedbackProvider state) {
    return Wrap(
      runSpacing: 10,
      spacing: 15,
      children: List.generate(state.uploadedImages.length, (index) {
        final image = state.uploadedImages[index];
        return _buildImagePreview(context, image, index, state);
      }),
    );
  }

  Widget _buildImagePreview(BuildContext context, UploadedMediaModel image, int index, SendFeedbackProvider state) {
    return Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(10),
            image: image.mediaType == MediaType.screenshot
                ? DecorationImage(
                    image: MemoryImage(image.mediaPath),
                    fit: BoxFit.cover,
                  )
                : image.mediaType == MediaType.image
                    ? DecorationImage(
                        image: FileImage(File(image.mediaPath)),
                        fit: BoxFit.cover,
                      )
                    : null,
          ),
          child: image.mediaType == MediaType.video ? const Icon(Icons.video_camera_back) : null,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => state.removeImage(index),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              radius: 10,
              child: const Icon(Icons.clear, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionSheet(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.5,
      initialChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: suggestionActions
                  .where((action) => action.type != FeedbackActionType.none)
                  .map((action) => _buildSuggestionAction(context, action))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  ListTile _buildSuggestionAction(BuildContext context, FeedbackActionModel action) {
    return ListTile(
      leading: CircleAvatar(child: Icon(action.icon)),
      title: Text(action.title),
      onTap: () async {
        switch (action.type) {
          case FeedbackActionType.screenshot:
            context.read<FeedbackProvider>().setFeedbackActionType(FeedbackActionType.screenshot);
            Navigator.pop(context);
            break;
          case FeedbackActionType.recording:
            context.read<FeedbackProvider>().setFeedbackActionType(FeedbackActionType.recording);
            Navigator.pop(context);
            break;
          case FeedbackActionType.file:
            context.read<FeedbackProvider>().setFeedbackActionType(FeedbackActionType.file);
            final imageResult = await pickImage();
            if (imageResult != null && context.mounted) {
              context
                  .read<SendFeedbackProvider>()
                  .addImage(UploadedMediaModel(mediaPath: imageResult, mediaType: MediaType.image));
            }
            break;
          case FeedbackActionType.none:
            break;
        }
      },
    );
  }

  void _handleSubmit(BuildContext context, SendFeedbackProvider state) {
    if (state.userIdEmail.isEmpty || state.userAdditionalMessage.isEmpty || state.uploadedImages.isEmpty) return;

    final result = FeedbackMediaResultModel(
      emailId: state.userIdEmail,
      feedbackType: state.feedbackType ?? FeedbackType.bug,
      message: state.userAdditionalMessage,
      media: state.uploadedImages.map((e) => Media(type: e.mediaType.name, url: e.mediaPath)).toList(),
    );

    context.read<FeedbackProvider>().setFeedbackResult(result);
    context.read<FeedbackProvider>().setFeedbackActionType(FeedbackActionType.none);
    Navigator.pop(context);
  }
}
