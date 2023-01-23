import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/screen/commentPage.dart';

class DetailAnnonce extends StatefulWidget {
  String auteur;
  String annonce;
  String id;
  int likes;
  List commentaires;
  String date;
 
  DetailAnnonce(this.annonce,this.auteur, this.id, this.likes, this.commentaires, this.date, {Key? key}) : super(key: key);
  
  @override
  State<DetailAnnonce> createState() => _DetailAnnonceState(annonce, auteur, id, likes, commentaires, date );
}

class _DetailAnnonceState extends State<DetailAnnonce> {
  void addLikes(String docID, int likes){
    var newLikes = likes + 1;
    try{
      FirebaseFirestore.instance.collection('Annonce').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("données à jour"));}catch(e){
        print(e.toString());
      }
    }
  String _auteur;
  String _annonce;
  String _id;
  int _likes;
  List _commentaires;
  String _date;
  
  _DetailAnnonceState(this._annonce, this._auteur, this._id, this._likes, this._commentaires, this._date);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Detail Annonce")),
        backgroundColor: Colors.blue,
      ),
      body:  Padding(
            padding: EdgeInsets.all(10),
             child:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("AG", style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),),
                Text(_annonce, style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),),
                Text("Posté par " +_auteur, style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.none),),
                Text("Date: Le "+ _date, style: TextStyle(color: Colors.black, fontSize: 10, decoration: TextDecoration.none),),
                SizedBox(height: 7,),
                //Text(_id, style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),),
Container(
  padding: EdgeInsets.all(10),
  height: 40,
  color: Colors.blue,
  child:
Row(
  children: [
 Row(
  
  children: [
          IconButton(onPressed: (){
          addLikes(_id, _likes);
                        }, 
          icon:Icon(Icons.favorite)),
         // SizedBox(height: 10,),
          Text(_likes.toString())
          ],),

       SizedBox(width: 70,),

  InkWell(
    child: Text("Comment", style: TextStyle(color: Colors.white, fontSize: 15),),
      onTap:(){
       Navigator.push(context, 
       MaterialPageRoute(builder: (context) => CommentPage(_id) ));}),

       SizedBox(width: 70,),
  InkWell(
    child: Text("Share", style: TextStyle(color: Colors.white, fontSize: 15),),
      onTap:(){
       Navigator.push(context, 
       MaterialPageRoute(builder: (context) => CommentPage( _id) ));})
       
      
],)),
SizedBox(height: 10,),


 Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Commentaires", style:TextStyle(fontSize: 20)),
                          SizedBox(height: 10,),
                          for(final categorie in _commentaires)
                            Column(
                              children:[
                            Row(
                              children:[
                                Icon(Icons.person),
                                SizedBox(width: 3,),
                          Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                         //   color: Colors.blue,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                            child: Text(categorie),),                  
                         )
                       ]
                            ), 
                            SizedBox(height: 10,)
                        ],
                      ),

                  ],
                  )]))
    );
    
  }
}