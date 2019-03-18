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
exports.getUserInfo = functions.https.onRequest((request, response) => {

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



// Listen for updates to any `user` document.
exports.addWorkout= functions.https.onCall((data, context) => {

    const workoutType = data["workoutType"] || "Unknown"
    const bonus_xp = data["bonus_xp"]
    const total_xp = data["total_xp"]
    console.log(data["bonus_xp"])
    const date = data["date"] || "Unknown"

    var info = {
                bonus_xp: bonus_xp,
                date: date,
                total_xp: total_xp,
                workoutType: workoutType,
                }
    var exercises = {XP: 1, name: "squat", repetitions: 10-12}

     return admin.firestore().collection('Users').doc("CC9zGkKATIf5JPndq197B68QMc92").collection("Workouts").add(info)
     .then(docRef => {
               console.log("Document written with ID: ", docRef.id);
                return admin.firestore().collection('Users').doc("CC9zGkKATIf5JPndq197B68QMc92").collection("Workouts").doc(docRef.id).collection("Exercises").add(exercises);

           })
                      .catch(function(error) {
                          console.error("Error adding document: ", error);
                      });


});