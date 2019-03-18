// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

//The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

 // Get username and email for settings page
exports.getSettingsUserInfo = functions.https.onRequest((request, response) => {

    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
    .then( decoded => {

        const userId = decoded.user_id;

        return admin.firestore().collection('Users').doc(userId).get()
        .then(querySnapshot => {

            const data = querySnapshot.data();

            return response.send({
                data: {
                    username: data.Username,
                    email: decoded.email
                }
            })
        })
        .catch(error => {
            response.status(400).send(error) // 400 bad request
        })
    })
    .catch( error => {
        // 401 is unauthorized.
        result.status(401).send(error)
    })
});


const helpers = require('./helper_functions.js');

// Get username, level, xp and xpCap for current level for home page
exports.getUserInfo = functions.https.onRequest((request, response) => {

    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
    .then( decoded => {

        const userId = decoded.user_id;

        return helpers.getUserInfo(userId)
        .then(data => {

            return response.send({
                data
            })
        })
        .catch(error => {
            response.status(400).send(error) // 400 bad request
        })
    })
    .catch( error => {
        // 401 is unauthorized.
        result.status(401).send(error)
    })
});


// Updates user level info: xp, level and xpCap for current level if level is updated.
// Returns new values.
exports.updateUserLevelInfo = functions.https.onRequest((request, response) => {

    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
    .then( decoded => {

        const userId = decoded.user_id;

        return helpers.updateUserLevelInfo(userId)
        .then(data => {

            return response.send({
                data
            })
        })
        .catch(error => {
            response.status(400).send(error) // 400 bad request
        })
    })
    .catch( error => {
        // 401 is unauthorized.
        result.status(401).send(error)
    })
});
