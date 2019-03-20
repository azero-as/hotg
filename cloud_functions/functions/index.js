

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

//The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

/**
 * Helpful links
 * For getting the token id:            https://stackoverflow.com/questions/42751074/how-to-protect-firebase-cloud-function-http-endpoint-to-allow-only-firebase-auth
 * For authorizing with the database:   https://stackoverflow.com/questions/48575730/how-to-protect-firebase-cloud-function-http-endpoint-using-authenticated-id-toke
 */


// Get email and username for current user
// TODO: delete this function when we have state management in the app 
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

/*const helpers = require('./helper_functions.js');

// Gets Username, XP, Level and xpCap from current user
exports.getUserInfo = functions.https.onRequest((request, response) => {

    const tokenId = request.get('Authorization').split('Bearer ')[1];
    return admin.auth().verifyIdToken(tokenId)
    .then( decoded => {
        
        const userId = decoded.user_id;

        helpers.getUserInfo(userId)
        .then( (userInfo) => {
            response.send(userInfo)
            })
        })
        .catch(error => {
            // 401 is unauthorized.
            result.status(401).send(error)
    })
})

*/
exports.helloWorld = functions.https.onRequest((request, response) => {

    let msg = {
        data: { // must be here for flutter
            msg: "Hello from Firebase!",
            version: 10,
        }
    };
    
    response.send(msg);
});


// Returns a list of all user workouts objects 
exports.getAllUserWorkouts = functions.https.onRequest((request, response) => {

        // user: lenatorresdal
        const userId = 'TkDkU5X55RG9rNjSb6Fn'

        return helpers.getAllUserWorkouts(userId)
        .then(data => {

            return response.send({
                data
            })
        })
        .catch(error => {
            response.status(400).send(error) // 400 bad request
        })
   
})
