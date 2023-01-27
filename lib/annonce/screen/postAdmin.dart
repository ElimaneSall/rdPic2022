import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

class PostAdmin extends StatefulWidget {
  const PostAdmin({Key? key}) : super(key: key);

  @override
  State<PostAdmin> createState() => _PostAdminState();
}

class _PostAdminState extends State<PostAdmin> {
  final titrecontroller = TextEditingController();
  final annoncecontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final postecontroller = TextEditingController();
  final statuscontroller = TextEditingController();

  List<String> auteurs = ['Bassirou', 'Fary', 'Aicha'];
  String? selectedAuteur = "Bassirou";

  List<String> postes = [
    'Commission Pédagogique',
    'Commission Culturelle',
    'Sécrétariat général'
  ];
  String? selectedPoste = "Commission Pédagogique";

  List<String> status = ['urgent', 'Moins Urgent', 'Facultatif'];
  String? selectedStatus = "urgent";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text('Faire une annonce'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.white)),
                    title: Row(children: [
                      Text('Auteur:'),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: DropdownButton(
                            value: selectedAuteur,
                            items: auteurs
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) => setState(
                                () => selectedAuteur = item as String?),
                          ))
                    ]),
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.white)),
                    title: Row(children: [
                      Text('Poste:'),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: DropdownButton(
                            value: selectedPoste,
                            items: postes
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) =>
                                setState(() => selectedPoste = item as String?),
                          ))
                    ]),
                  ),
                  reusableTextField("Titre de l'annonce", Icons.edit_sharp,
                      false, titrecontroller, Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Annonce", Icons.edit_sharp, false,
                      annoncecontroller, Colors.blue),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.white)),
                    title: Row(children: [
                      Text('Statut:'),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: DropdownButton(
                            value: selectedStatus,
                            items: status
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) => setState(
                                () => selectedStatus = item as String?),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton("Poster l'annonce", context, false, () {
                    FirebaseFirestore.instance.collection('Annonce').add({
                      'titre': titrecontroller.value.text,
                      'annonce': annoncecontroller.value.text,
                      'auteur': selectedAuteur,
                      'date': DateTime.now(),
                      'poste': selectedPoste,
                      'status': selectedStatus,
                      "idUser": FirebaseAuth.instance.currentUser!.uid,
                      'commentaires': [],
                      'likes': 0,
                      'unlikes': 0,
                    });
                    Navigator.pop(context);
                  })
                ]))));
  }
}
