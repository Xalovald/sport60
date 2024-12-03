import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sport60/domain/comment_domain.dart';
import 'package:sport60/services/comment_service.dart';
import 'dart:io';

class CommentWidget extends StatefulWidget {
  final int sessionId;
  final int? exerciseId;

  CommentWidget({required this.sessionId, this.exerciseId});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final SpeechToText _speechToText = SpeechToText();
  bool _isRecording = false;
  String _transcribedText = '';

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await Permission.microphone.request();
  }

  Future<void> _addComment() async {
    String commentText = _commentController.text;
    if (commentText.isNotEmpty) {
      CommentDomain comment = CommentDomain(
        sessionId: widget.sessionId,
        exerciseId: widget.exerciseId,
        comment: commentText,
        isGlobal: false,
      );
      int commentId = await _commentService.addComment(comment);
      if (commentId != null) {
        // Le commentaire a été ajouté avec succès
        _commentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Commentaire ajouté avec succès!')),
        );
      } else {
        // Gérer l'échec de l'ajout du commentaire
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'ajout du commentaire.')),
        );
      }
    } else {
      // Gérer le cas où le champ de texte est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un commentaire.')),
      );
    }
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      await _speechToText.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (errorNotification) =>
            print('Error: ${errorNotification.errorMsg}'),
      );
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _transcribedText = result.recognizedWords;
            _commentController.text = _transcribedText;
          });
        },
      );
      setState(() {
        _isRecording = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission de microphone refusée.')),
      );
    }
  }

  Future<void> _stopRecording() async {
    await _speechToText.stop();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Écrire un commentaire',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
              Text(_isRecording ? 'Enregistrement...' : 'Enregistrer un audio'),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _addComment,
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _recorder.closeRecorder();
    _speechToText.stop();
    super.dispose();
  }
}