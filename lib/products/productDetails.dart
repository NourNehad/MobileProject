import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:test/cart/cartProvider.dart';
import 'package:test/vendor/vendorProvider.dart';
import 'package:test/notification_service_stub.dart';

class productDetails extends StatelessWidget {
  final String productId;
  final TextEditingController _commentController = TextEditingController();
  String username = '';

  productDetails({required this.productId});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<VendorProvider>(context);
    bool isAuth = authProvider.isAuth;
    username = authProvider.username;

    final CartProvider = Provider.of<cartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found'));
          }

          var product = snapshot.data!.data() as Map<String, dynamic>;
          var ratings = product['ratings'] as List<dynamic>? ?? [];
          double averageRating = ratings.isNotEmpty
              ? ratings.reduce((a, b) => a + b) / ratings.length
              : 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(product['imageUrl'], height: 200, fit: BoxFit.cover),
                SizedBox(height: 16),
                Text(
                  product['title'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(product['description']),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StarRating(
                      rating: averageRating,
                      onRatingChanged: (rating) {
                        if (isAuth) {
                          addRating(productId, rating, product['title']);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You must be logged in to rate.')),
                          );
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product['price']}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        CartProvider.addToCart(productId);
                        Navigator.pushNamed(context, '/cart');
                      },
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(),
                Expanded(
                  child: CommentsSection(productId: productId, isAuth: isAuth, productTitle: product['title']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addRating(String productId, double rating, String productTitle) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(productId);

    await productRef.update({
      'ratings': FieldValue.arrayUnion([rating])
    });
    print(username);
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var notificationMessage = '${username} rated $productTitle';

      // Add notification to Firestore
      FirebaseFirestore.instance.collection('notifications').add({
        'message': notificationMessage,
        'timestamp': DateTime.now(),
      });
    }
  }
}

class CommentsSection extends StatelessWidget {
  final String productId;
  final bool isAuth;
  final String productTitle;
  final TextEditingController _commentController = TextEditingController();
  String username = '';

  CommentsSection({required this.productId, required this.isAuth, required this.productTitle});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<VendorProvider>(context);
    bool isAuth = authProvider.isAuth;
    username = authProvider.username;
    var currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .collection('comments')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No comments yet'));
              }

              var comments = snapshot.data!.docs;

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  var comment = comments[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(comment['username']),
                    subtitle: Text(comment['comment']),
                    trailing: Text(
                      (comment['timestamp'] as Timestamp).toDate().toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (isAuth) {
                    if (_commentController.text.isNotEmpty) {
                      addComment(
                        productId,
                        currentUser!.uid,
                        username,
                        _commentController.text,
                      );
                      _commentController.clear();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You must be logged in to comment.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void addComment(String productId, String userId, String username, String comment) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).collection('comments').add({
      'userId': userId,
      'username': username,
      'comment': comment,
      'timestamp': Timestamp.now(),
    });

    var notificationMessage = '$username commented on $productTitle';

    // Add notification to Firestore
    FirebaseFirestore.instance.collection('notifications').add({
      'message': notificationMessage,
      'timestamp': DateTime.now(),
    });

    // Send push notification
    sendPushNotification(notificationMessage);
  }

  void sendPushNotification(String message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'New Comment',
        body: message,
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  final double rating;
  final Function(double rating) onRatingChanged;

  StarRating({required this.rating, required this.onRatingChanged});

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
          ),
          color: Colors.amber,
          onPressed: () {
            setState(() {
              _currentRating = index + 1.0;
            });
            widget.onRatingChanged(_currentRating);
          },
        );
      }),
    );
  }
}
