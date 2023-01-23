import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/model/menu.dart';
import 'package:tuto_firebase/screen/detaitl_screen.dart';

class MenuCard extends StatelessWidget {
   final Menu menu;
   MenuCard(this.menu);
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap:(){
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => DetailScreen(menu.id, menu.image, menu.isPromo, menu.name, menu.note) ));
      },
    child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       
      children: [
      Row(
        
        children:[
          ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width:130,
            height:110,
            child:
            Image.network(
            menu.image,
            fit:BoxFit.cover,
          ))),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              menu.isPromo?Container(
                color: Colors.green,
                child: const Text("Promo",
                style: TextStyle(
                  color: Colors.red,
                ),
                ),
              )
              :Container(
                color: Colors.blue,
                child: Text("New",
                style: TextStyle(
                  color: Colors.white,
                ),),
              ),
              SizedBox(height: 4,),
             Row(children: [
              Text(
                'Prix${10}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:Colors.blue,
                  decoration: TextDecoration.lineThrough
                ),
              ),
              SizedBox(height: 4,),
              Text(
                'Rp${102}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:Colors.yellow,
                  decoration: TextDecoration.lineThrough
                ),
              ),
              SizedBox(height: 4,),
              Text(
                'Free Delivery',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.green
                ),
              )
             ],)
            ],
          )
        ]
      ),
      SizedBox(height: 20,)]
      )
    );
  }
}