const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

// Helper functions: 
const helpers = require("./helper_functions.js");

/*
  Get characterName, gameLevel, xp, className from Users Collection
  Get email from Firebase Authentication
  Get xpCap based on what gameLevel the current user is in from Levels Collection
*/
exports.getUserInfo = functions.https.onRequest((request, response) => {
  
  const tokenId = request.get("Authorization").split("Bearer ")[1];

  return admin
    .auth()
    .verifyIdToken(tokenId)
    .then(decoded => {
      const email = decoded.email;
      const userId = decoded.user_id;
      
      return helpers
      .getUserInfo(userId, email)
      .then(data => {
        return response.send({
          data
        })
      })
      .catch(error => {
        response.status(400).send(error) // 400 bad request
      })
    })
    .catch(error => {
      result.status(401).send(error) // 401 is unauthorized.
    })
})

/*
Updates user level info: xp, gameLevel and xpCap when user is leveling up 
Returns new values.
*/
exports.updateUserLevelInfo = functions.https.onCall((data, context) => {
  
  // Check if user is authenticated: 
  if (context.auth.uid != null) {

    var userId = context.auth.uid
    
    // parameters
    const userXp = data.xp
    const xpCap = data.xpCap
    const gameLevel = data.level
    
    return helpers
    .updateUserLevelInfo(userId, userXp, xpCap, gameLevel)
    .then(data => {
      return data
    })
    .catch((error) => { 
      throw new functions.https.HttpsError(error.code, error.message)
    }) 
  }
  else {
    // not authenticated: 
    throw new functions.https.HttpsError(code, message)
  }
})

/*
Get xpEarned from finished workout, and updates the
total amount of xp in the User collection
*/
exports.updateUserXp = functions.https.onCall((data, context) => {
  
  if (context.auth.uid != null) {
    
    var userId = context.auth.uid
    
    // parameter
    const xpEarned = data.xpEarned
    
    return helpers
    .updateUserXp(userId, xpEarned)
    .then(data => {
      return data
    })
    .catch((error) => { 
      throw new functions.https.HttpsError(error.code, error.message)
    })  
  }
  else {
    // not authenticated: 
    throw new functions.https.HttpsError(code, message)
  }
})

// Get one "recommended" workout based on className at homepage
exports.getRecommendedWorkout = functions.https.onCall((data, context) => {
  
  // Check if user is authenticated: 
  if (context.auth.uid != null) {
    
    // parameters
    const className = data.className
    
    return helpers.getRecommendedWorkout(className)
    .then(data => {
      return data
    })
    .catch((error) => { 
      throw new functions.https.HttpsError(error.code, error.message)
    }) 
  }
  else {
    // not authenticated: 
    throw new functions.https.HttpsError(code, message)
  }
})


// Saves finished workout in Users collection Users --> Workouts
exports.saveCompletedWorkout = functions.https.onCall((data, context) => {
  if (context.auth.uid != null) {
    
    var userId = context.auth.uid
    
    const workoutType = data["workoutType"] || "Unknown"
    const bonus_xp = data["bonus_xp"]
    const total_xp = data["total_xp"]
    const selectedExercises = data["exercises"]
    
    var info = {
      bonus_xp: bonus_xp,
      date: admin.firestore.FieldValue.serverTimestamp(),
      total_xp: total_xp,
      workoutType: workoutType,
      exercises: selectedExercises
    }

    return admin
    .firestore()
    .collection("Users")
    .doc(userId)
    .collection("Workouts")
    .add(info)
    .catch((error) => { 
      throw new functions.https.HttpsError(error.code, error.message)
    }) 
  }
  else {
    // Not authenticated:
    throw new functions.https.HttpsError(code, message)
  }
})

// Get all completed workouts from Users --> Workouts collection
exports.getCompletedUserWorkouts = functions.https.onRequest((request, response) => {

  const tokenId = request.get("Authorization").split("Bearer ")[1];
  
  return admin
  .auth()
  .verifyIdToken(tokenId)
  .then(decoded => {
    const userId = decoded.user_id;
    return helpers
    .getCompletedUserWorkouts(userId)
    .then(workouts => {
      return response.send({
        data: {
          workouts: workouts
        }
      })
    })
    .catch(error => {
      response.status(400).send(error) // 400 bad request
    })
  })
  .catch(error => {
    result.status(401).send(error) // 401 is unauthorized.
  })
})

// Get all workouts from the Workouts collection
exports.getAllWorkouts = functions.https.onRequest((request, response) => {
  return helpers.getAllWorkouts()
  .then(workoutList => {
    return response.send({
      data: {
        workoutList: workoutList
      }
    })
  })
  .catch(error => {
    response.status(400).send(error); // 400 bad request
  })
})
