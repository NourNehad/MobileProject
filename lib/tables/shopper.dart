
import "package:test/tables/comment.dart";
import "package:test/tables/order.dart";


class shopper {
   String id;
   String name;
   String email;
   List<comment> comments; 
   List<order> orders; 

  shopper({
    required this.id,
    required this.name,
    required this.email,
    required this.comments,
    required this.orders,
  });
}