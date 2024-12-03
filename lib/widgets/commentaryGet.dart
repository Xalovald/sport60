import 'package:flutter/material.dart';
import 'package:sport60/domain/comment_domain.dart';
import 'package:sport60/services/comment_service.dart';

class CommentListWidget extends StatefulWidget {
  final int sessionId;
  final int? exerciseId;

  CommentListWidget({required this.sessionId, this.exerciseId});

  @override
  _CommentListWidgetState createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  final CommentService _commentService = CommentService();
  List<CommentDomain> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    List<CommentDomain> comments =
        await _commentService.getComment(widget.sessionId, widget.exerciseId);
    setState(() {
      _comments = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _fetchComments,
            child: Text('Rafraîchir les commentaires'),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                CommentDomain comment = _comments[index];
                return ListTile(
                  title: Text(comment.comment),
                  subtitle: Text(
                      'Session ID: ${comment.sessionId}, Exercise ID: ${comment.exerciseId}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
