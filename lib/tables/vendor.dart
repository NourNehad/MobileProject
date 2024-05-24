
import "package:test/tables/product.dart";
class vendor {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final List<product> products; 

  vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.products,
  });
}