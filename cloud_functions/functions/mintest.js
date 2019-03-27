
// For debugging and testing locally


var admin = require("firebase-admin");

var serviceAccount = require("./minkey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://heroes-6fe69.firebaseio.com"
});

//const userId = '0EWvvdAUc2QEJn6ChySZU0iTXmF2';
