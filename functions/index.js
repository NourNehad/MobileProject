const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");


const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendCommentNotification = functions.firestore
  .document('products/{productId}/comments/{commentId}')
  .onCreate((snap, context) => {
    const comment = snap.data();
    const productId = context.params.productId;

    const payload = {
      notification: {
        title: 'New Comment',
        body: `${comment.username} commented: ${comment.comment}`,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK', // Ensure this matches the action in your app
      },
      data: {
        productId: productId,
      },
    };

    // Get all device tokens
    return admin.firestore().collection('users').get().then((snapshot) => {
      const tokens = [];
      snapshot.forEach((doc) => {
        const token = doc.data().fcmToken; // Ensure you store the FCM token in the user's document
        if (token) {
          tokens.push(token);
        }
      });

      if (tokens.length > 0) {
        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('Successfully sent message:', response);
        }).catch((error) => {
          console.error('Error sending message:', error);
        });
      }
      return null;
    });
  });
