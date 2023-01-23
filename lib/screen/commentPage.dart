import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  
//   List<String> _comments = [];

//   void _addComment(String val){
//     setState(() {
//       _comments.add(val);
//     });
//   }
  
//   Widget _buildCommentList(){
//     return ListView.builder(
//       itemBuilder:((context, index) {
// if(index < _comments.length){
//   return _buildCommentItem(_comments[index]);
// }
//       } ) );
//   }

//   Widget _buildCommentItem(String comment){
//     return ListTile(
//       title: Text(comment),
//     );
//   }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page des commentaires"),
      ),
      body: Column(
        children: [
          Text("sall")
        ],
      ),
    );
  }
}