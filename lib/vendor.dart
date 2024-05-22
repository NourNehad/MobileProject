
import "package:test/product.dart";
class vendor {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final List<product> products; // List of products listed by the vendor

  vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.products,
  });
}