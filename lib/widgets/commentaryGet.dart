import 'package:flutter/material.dart';
import 'package:sport60/domain/comment_domain.dart';
import 'package:sport60/services/comment_service.dart';
import 'package:sport60/widgets/button.dart';

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
    // List<CommentDomain> comments =
    //     await _commentService.getComment(widget.sessionId, widget.exerciseId);
    //     print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
    //     print(comments.length);
    // setState(() {
    //   _comments = comments;
    // });
    try {
      // Appel à la méthode du service pour récupérer les commentaires
      List<CommentDomain> comments = await _commentService.getComment(widget.sessionId, widget.exerciseId);
      // Affichage pour vérifier si des commentaires sont récupérés
      print("Commentaires récupérés : ${comments[0].comment}");

      // Mise à jour de l'état pour afficher les commentaires récupérés
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      // Gestion des erreurs en cas de problème lors de la récupération des commentaires
      print("Erreur lors de la récupération des commentaires : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Commentaires",
            style: TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.bold,
              color: Colors.black87, 
            ),
          ),

          if(_comments.isEmpty) ...[
            const Text('Aucun commentaire sur cette séance.')
          ]
          else ... [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                CommentDomain comment = _comments[index];
                return Card(
                  elevation: 5, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.comment,
                      color: Colors.purple.shade700,
                    ),
                    title: Text(
                      comment.comment,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, 
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            )

          ],
          

          const SizedBox(height: 20),

          CustomButton(
            onClick: _fetchComments,
            heroTag: 'RefreshComment',
            width: MediaQuery.of(context).size.width * 0.7,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: Colors.purple,
              border: Border.all(color: Colors.deepPurple.shade800, width: 2),
            ),
            child: const Text(
              "Rafraîchir",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
