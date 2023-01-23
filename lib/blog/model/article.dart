class Article{
  String id;
 // String idd;
  String titre;
  String image;
  String auteur;
  String date;
  String description;
  int likes;
  List commentaire;
  String urlPDF;

Article({
  required this.id,
  required this.urlPDF,
  required this.image,
  required this.titre,
  required this.auteur,
  required this.date,
  required this.description,
  required this.likes,
  required this.commentaire,
});
}