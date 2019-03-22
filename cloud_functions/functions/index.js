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


    /**
     * The token id is sent like this in the request:
     * 'Authorization': 'Bearer xxxxxxxxxx'
     * so we need to find it and split it in two.
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



exports.getUserXP = functions.https.onRequest((request, response) => {
    /**
     * The token id is sent like this in the request:
     * 'Authorization': 'Bearer xxxxxxxxxx'
     * so we need to find it and split it in two.
     */
    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
        .then( decoded => {

            const userId = decoded.user_id;

            return admin.firestore().collection('Users').doc(userId).get()
                .then(querySnapshot => {

                    const data = querySnapshot.data();

                    return response.send({
                        data: {
                           XP: data.XP,
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

exports.getUserLevel = functions.https.onRequest((request, response) => {
    /**
     * The token id is sent like this in the request:
     * 'Authorization': 'Bearer xxxxxxxxxx'
     * so we need to find it and split it in two.
     */
    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
        .then( decoded => {

            const userId = decoded.user_id;

            return admin.firestore().collection('Users').doc(userId).get()
                .then(querySnapshot => {

                    const data = querySnapshot.data();

                    return response.send({
                        data: {
                            Level: data.Level,
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

exports.getLevelCaps = functions.https.onRequest((req, res) => {
    var list = [];
    var ref = admin.firestore.collection('Levels');
    var allLevels = ref.get()
        .then(snapshot => {
            snapshot.forEach(doc => {
                list.add(doc.id);
                console.log(doc.id, '=>', doc.data())
       });
            return response.send({
            })
       }).catch( error => {
            // 401 is unauthorized.
            result.status(401).send(error)
    });

});

exports.setLevel = functions.https.onRequest((req, res) => {

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




exports.getExercises  = functions.https.onRequest((request, response) => {

        return admin.firestore().collection('Users').doc("CC9zGkKATIf5JPndq197B68QMc92").collection("Workouts").doc("2sBmiDB5vBMnWLswuCnz").get()
                .then(querySnapshot => {

                    const data = querySnapshot.data();

                    return response.send({data})
                })
                .catch(error => {
                    response.status(400).send(error) // 400 bad request
                })

        .catch( error => {
            // 401 is unauthorized.
            result.status(401).send(error)
        })
});


exports.getWorkout  = functions.https.onRequest((request, response) => {

        return admin.firestore().collection("Workouts").doc("w7ujyNOojW4QAE4GV4wc").get()
                .then(querySnapshot => {

                    const data = querySnapshot.data();

                    return response.send({data})
                })
                .catch(error => {
                    response.status(400).send(error) // 400 bad request
                })

        .catch( error => {
            // 401 is unauthorized.
            result.status(401).send(error)
        })
});



// Listen for updates to any `user` document.
exports.addWorkout= functions.https.onCall((data, context) => {

    const workoutType = data["workoutType"] || "Unknown"
    const bonus_xp = data["bonus_xp"]
    const total_xp = data["total_xp"]
    const selectedExercises = data["exercises"]

    var info = { bonus_xp: bonus_xp,
                date: admin.firestore.FieldValue.serverTimestamp(),
                total_xp: total_xp,
                workoutType: workoutType,
                exercises: selectedExercises,
                }

     return admin.firestore().collection('Users').doc("CC9zGkKATIf5JPndq197B68QMc92").collection("Workouts").add(info)

          .catch(function(error) {
              console.error("Error adding document: ", error);
          });


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

