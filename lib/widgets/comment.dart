import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final Function(String) onPost; // Callback when the comment is posted
  final String hintText; // Hint text for the input field (optional)

  const CommentWidget({
    Key? key,
    required this.onPost,
    this.hintText = 'Write a comment...',
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isPosting = false;

  void _postComment() async {
    final comment = _controller.text.trim();
    if (comment.isEmpty) return;

    setState(() {
      _isPosting = true;
    });

    // Call the callback function with the entered comment
    await widget.onPost(comment);

    // Clear the text field after posting
    _controller.clear();

    setState(() {
      _isPosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(),
          ),
          maxLines: null, // Allows multi-line input
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isPosting ? null : _postComment,
          child:
              _isPosting ? CircularProgressIndicator() : Text('Post Comment'),
        ),
      ],
    );
  }
}
