
var admin = require("firebase-admin");

var serviceAccount = require("./minkey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://heroes-6fe69.firebaseio.com"
});

const userId = '0EWvvdAUc2QEJn6ChySZU0iTXmF2';
//getXpCap(getUserLevel(userId));

/*getUserLevel(userId)
.then((userLevel) => {
    getUserXp(userId),
    getXpCap(userLevel);
    //checkUpdateLevel(xpCap, userXp, userLevel);

})
*/
var userLevel = getUserLevel(userId)
var userLevelString = userLevel.toString(); 
console.log(userLevelString)
var userXp = getUserXp(userId)
//let xpCap = getXpCap(userLevel)
//checkUpdateLevel(xpCap, userXp, userLevel)
getXpCap(userLevelString);
//getXpCap();


function getUserLevel(userId) {
    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        const userLevel = querySnapshot.data().Level;
        console.log('User level: ', userLevel);
        return userLevel;
    })
    .catch(function(error) {
        console.log('Error: ', error);
    });

}

function getUserXp(userId) {
    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        const userXp = querySnapshot.data().XP;
        console.log('User XP: ', userXp)
        return userXp;
    })
    .catch(function(error) {
        console.log('Error:', error);
    });
}

function getXpCap(userLevel) {
    return admin.firestore().collection('Levels').doc(userLevel).get()
    .then(querySnapshot => {
        const levelXpCap = querySnapshot.data().xpCap;
        console.log('XP cap: ', levelXpCap)
        return levelXpCap;
    })
    .catch(function(error) {
        console.log('Error:', error);
    });
}

/*function getXpCap(userLevel) {
    admin.firestore().collection('Levels').where('Level', '==', userLevel)
    .get()
    .then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
           // console.log('Cap: ', doc.data().xpCap);
            levelXpCap = doc.data().xpCap;
            console.log('XP Cap: ', levelXpCap)
            //return(levelXpCap)
        });
    })
    .catch(function(error) {
        console.log('Error: ', error);
    });
}
*/


function checkUpdateLevel(xpCap, userXp, userLevel) {
    if (userXp >= xpCap) {
        increaseLevel(userLevel)
        //resetUserXp(xpCap)
    }
    else {
        console.log('ingen endring')
    
    }
}
function increaseLevel() {
    console.log('icreseLevel()')

    admin.firestore.collection("Users").doc(userId).set({
        Level: (userLevel+1),
    })
    .then(function() {
        console.log("Document successfully written!");
        console.log()
    })
    .catch(function(error) {
        console.error("Error writing document: ", error);
    });

}