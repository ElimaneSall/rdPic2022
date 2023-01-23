import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';
import 'package:tuto_firebase/annonce/screen/detailAnnonce.dart';

import 'package:tuto_firebase/annonce/screen/detailEvenement.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;
   AnnonceCard(this.annonce);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
      padding: EdgeInsets.all(10),
      child:InkWell(
      onTap:(){
       Navigator.push(context, 
       MaterialPageRoute(builder: (context) => DetailAnnonce( annonce.annonce, annonce.auteur, annonce.id, annonce.likes,annonce.commentaires, annonce.date)));
      },
    child: Expanded(child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.blue,
          child:         
     
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
      Container(
                width: 20,
                height: 20,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: annonce.status =="urgent"? Colors.red: Colors.green),  
              ),
              SizedBox(width: 3,),
            Text(
                annonce.titre,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color:Colors.white,
                  //decoration: TextDecoration.lineThrough
                ),
              ),

             
              ],),
            
          
              SizedBox(height: 12,),
               SizedBox(
                width: 300,
        child:
              Text(
                annonce.annonce,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color:Colors.white,
                  //decoration: TextDecoration.lineThrough
                ),
              ),
               ),
               SizedBox(height: 12,),
              Text(
                annonce.auteur,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color:Colors.white,
                  //decoration: TextDecoration.lineThrough
                ),
              ),
              SizedBox(height: 4,),
              Text(
                annonce.poste,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ), 
              ),
              SizedBox(height: 4,),
              Text(
                annonce.date,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
                ),
              )
             ],)
            
          ),  
      SizedBox(height: 20,)]
      )))
    ));
  }
}