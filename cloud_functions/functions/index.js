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
                    username: data.characterName,
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

// Get characterName, gameLevel, xp, class and xpCap for current level for home page
exports.getUserInfo = functions.https.onRequest((request, response) => {

    const tokenId = request.get('Authorization').split('Bearer ')[1];

    return admin.auth().verifyIdToken(tokenId)
    .then( decoded => {

        const userId = decoded.user_id;
        console.log('UserId: ',userId)

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
})

// Get total_xp and bonus_xp from finished workout, and updates the
// total amount of XP in the User collection

exports.updateUserXpWorkout = functions.https.onCall((data, context) => {

    // Check if user is authenticated: 
    if (context.auth.uid != null) {

        var userId = context.auth.uid
        const total_xp = data.total_xp
        const bonus_xp = data.bonus_xp
     
        const totalWorkoutXp = total_xp + bonus_xp
        
        console.log(userId)


        return helpers.updateUserXpWorkout(userId, totalWorkoutXp)
        .then(data => {
            console.log(data)
            return data
        })
        .catch(error => {
            console.log(error)
            // return error
            return {}
        })  
    } else {
        // not authenticated: 
        throw new functions.https.HttpsError(code, message)

    }
})


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

// Get workout object based on className
exports.getWorkout2 = functions.https.onCall((data, context) => {

    // Check if user is authenticated: 
    if (context.auth.uid != null) {

        // parameters
        const className = data.className
        console.log('Classname: ', className)

        return helpers.getWorkout2(className)
        .then(data => {
            console.log('data:',data)
            return data
        })
        .catch(error => {
            console.log(error)
            // return error
            return {}
        })
    } else {
        // not authenticated: 
        throw new functions.https.HttpsError(code, message)

    }
})




// Listen for updates to any `user` document.
exports.addWorkout= functions.https.onCall((data, context) => {

    if (context.auth.uid != null) {
        var userId = context.auth.uid

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
            
            return admin.firestore().collection('Users').doc(userId)
            .collection("Workouts").add(info)
            
            .catch(function(error) {
                console.error("Error adding document: ", error);
          })
    }
    else {
        // Not authenticated:
        throw new functions.https.HttpsError(code, message)
    }

    

    

     


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

