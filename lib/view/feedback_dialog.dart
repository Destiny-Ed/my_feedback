import 'package:flutter/material.dart';
import 'package:my_feedback/models/feedback_type.dart';
import 'package:my_feedback/provider/send_feedback_provider.dart';
import 'package:my_feedback/view/send_feedback_page.dart';
import 'package:provider/provider.dart';

void showFeedbackModel(BuildContext context) {
  showModalBottomSheet<FeedbackModel?>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildFeedbackOptions(context),
            _buildCancelOption(context),
          ],
        ),
      );
    },
  ).then((value) {
    if (value != null && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SendFeedbackPage()));
    }
  });
}

List<Widget> _buildFeedbackOptions(BuildContext context) {
  return List.generate(needHelpData.length, (index) {
    final data = needHelpData[index];
    return ListTile(
      leading: Icon(data.icon),
      title: Text(data.title),
      subtitle: Text(data.description),
      onTap: () {
        context.read<SendFeedbackProvider>().setFeedbackType(data.type);
        Navigator.pop(context, data);
      },
    );
  });
}

Widget _buildCancelOption(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.cancel),
    title: const Text('Cancel'),
    onTap: () => Navigator.pop(context),
  );
}
