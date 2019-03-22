
// For debugging and testing locally


var admin = require("firebase-admin");

var serviceAccount = require("./minkey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://heroes-6fe69.firebaseio.com"
});

const userId = '0EWvvdAUc2QEJn6ChySZU0iTXmF2';


//getXpCap(getUserLevel(userId));

getUserLevel(userId)
.then((level) => {
    getXpCap(level);
})

function getUserLevel(userId) {
    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        const userLevel = querySnapshot.data().Level;
        return userLevel;
    })
    .catch(function(error) {
        console.log('Error: ', error);
    });

}

function getXpCap(level) {
    admin.firestore().collection('Levels').where('Level', '==', level)
    .get()
    .then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
            console.log(doc.data().xpCap);
        });
    })
    .catch(function(error) {
        console.log('Error: ', error);
    });
}

//const userId = '0EWvvdAUc2QEJn6ChySZU0iTXmF2';
