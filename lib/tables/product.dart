
enum ProductCategory {
  Necklace,
  Ring,
  Bracelet,
  Earring,
  Watch,
  Other,
}

class product {
  String id;
  String title;
  String description;
  String price; 
  String imageUrl;
  String vendorid;
  DateTime timeCreated;
  List<double> ratings;
   ProductCategory Category;

product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.vendorid,
    required this.timeCreated,
    required this.Category,
    this.ratings= const [],
});
}