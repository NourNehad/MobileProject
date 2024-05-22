
import "package:test/product.dart";
import "package:test/shopper.dart";


class order {
   String id;
   List<product> products; // List of products in the order
   double totalPrice;
   DateTime orderDate;
   shopper Shopper; // The shopper who made this order

  order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.orderDate,
    required this.Shopper,
  });
} 
