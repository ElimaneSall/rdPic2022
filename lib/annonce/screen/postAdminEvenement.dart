import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

class PostAdminEvenement extends StatefulWidget {
  const PostAdminEvenement({Key? key}) : super(key: key);

  @override
  State<PostAdminEvenement> createState() => _PostAdminEvenementState();
}

class _PostAdminEvenementState extends State<PostAdminEvenement> {
  final titrecontroller = TextEditingController();
  final imagecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final postecontroller = TextEditingController();
  final statuscontroller = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<String> status = ['urgent', 'Moins Urgent', 'Facultatif'];
  String? selectedStatus = "urgent";

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  String url = "";
  Future<void> uploadImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    String filename = pickedImage.name;
    File imageFile = File(pickedImage.path);

    Reference reference = firebaseStorage.ref(filename);

    try {
      setState(() {
        loading = true;
      });
      await reference.putFile(imageFile);
      url = (await reference.getDownloadURL()).toString();

      setState(() async {
        loading = false;
        url = (await reference.getDownloadURL()).toString();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success upload")));

      print("SamaUrl" + url);
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Poster un evenement'),
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  reusableTextField("Auteur", Icons.add, false,
                      auteurcontroller, Colors.blue),
                  SizedBox(
                    height: 15,
                  ),
                  reusableTextField(
                      "Poste", Icons.add, false, postecontroller, Colors.blue),
                  SizedBox(
                    height: 15,
                  ),
                  reusableTextField(
                      "Titre", Icons.add, false, titrecontroller, Colors.blue),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Statut'),
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
                          )),
                    ],
                  ),
                  InputDatePickerFormField(
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                    initialDate: selectedDate,
                    onDateSubmitted: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ElevatedButton.icon(
                        onPressed: () async {
                          await uploadImage();
                        },
                        icon: Icon(
                          Icons.library_add,
                        ),
                        label: Text("Image"),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  signInSignUpButton(
                    "Poster",
                    context,
                    false,
                    () async {
                      await FirebaseFirestore.instance
                          .collection('Evenement')
                          .add({
                        'titre': titrecontroller.value.text,
                        'auteur': auteurcontroller.value.text,
                        'description': auteurcontroller.value.text,
                        'date': selectedDate,
                        'poste': postecontroller.value.text,
                        'status': statuscontroller.value.text,
                        "image": url,
                        'commentaires': [],
                        'likes': 0,
                        'unlikes': 0,
                      });
                      Navigator.pop(context);
                    },
                  )
                ]))));
  }
}
