class product {
  String id;
  String title;
  String description;
  String price; 
  String imageUrl;
  String vendorid;
  DateTime timeCreated;

product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.vendorid,
    required this.timeCreated
});
}