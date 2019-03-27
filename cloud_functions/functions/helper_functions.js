var admin = require("firebase-admin");

module.exports = {
    getUserInfo: getUserInfo,
    getAllUserWorkouts: getAllUserWorkouts,
    getWorkout2: getWorkout2,
    getAllWorkouts: getAllWorkouts,
    updateUserLevelInfo: updateUserLevelInfo,
    updateUserXpWorkout: updateUserXpWorkout,
}

// Get user info from Users collection, email and xpCap based on current gameLevel
async function getUserInfo(userId, email) {

    // Array from getUserCollection
    var userCollection = await getUsersCollection(userId)
    var gameLevel = userCollection[0]
    var userXp = userCollection[1]
    var characterName = userCollection[2]
    var className = userCollection[3]

    let gameLevelString = gameLevel.toString()
    var xpCap = await getLevelXpCap(gameLevelString)

    return {
        characterName: characterName,
        gameLevel: gameLevel,
        userXp: userXp,
        xpCap: xpCap,
        className: className,
        email: email
    }
}


// Returns updated level info: xp, level and xp cap
async function updateUserLevelInfo(userId, userXp, xpCap, userLevel) {

    var newUserLevel = await increaseLevel(userLevel, userId)
    var newUserXp = await resetUserXp(xpCap, userXp, userId)

    let newUserLevelString = newUserLevel.toString()
    var newXpCap = await getLevelXpCap(newUserLevelString)

    // Update values
    var userXp = await newUserXp
    var userLevel = await newUserLevel
    var xpCap = await newXpCap


    return {
        userLevel: userLevel,
        userXp: userXp,
        xpCap: xpCap,
    }

}
// Update user xp with xp earned from finishing a workout

async function updateUserXpWorkout(userId, xpEarned) {
    var userCollection = await getUsersCollection(userId)
    var currentXp = userCollection[1]
    var updatedXp = await updateUserXP(currentXp, xpEarned, userId)

    return {
        updatedXp: updatedXp // New XP
    }
}
      
// Get gameLevel, xp, charactername and class from Users collection
async function getUsersCollection(userId) {

    return admin.firestore()
    .collection('Users')
    .doc(userId)
    .get()
    .then(querySnapshot => {
        var gameLevel = querySnapshot.data().gameLevel
        var userXp = querySnapshot.data().xp
        var characterName = querySnapshot.data().characterName
        var className = querySnapshot.data().class

        return [gameLevel, userXp, characterName, className]
    })
    .catch(function(error) {
        console.log('Error getting data from User collection. ', error)
    })
}


// Get xpCap for current gameLevel from Levels collection
async function getLevelXpCap(gameLevel) {
    return admin.firestore()
    .collection('Levels')
    .doc(gameLevel)
    .get()
    .then(querySnapshot => {
      const levelXpCap = querySnapshot.data().xpCap;
      return levelXpCap;
    })
    .catch(function(error) {
        console.log('Error getting data from Levels collection. ', error)
    })
    .catch(function(error) {
      console.log("Error: ", error);
    });
}


// Increase level by 1
async function increaseLevel(userLevel, userId) {
    const newUserLevel = userLevel+1
    return admin.firestore().collection("Users").doc(userId).update({
        gameLevel: newUserLevel,
       
    })
    .then(function() {
        return newUserLevel
    })
    .catch(function(error) {
        console.error("Error writing document: ", error)
    })

}
// Returns new user XP if level is updated
async function resetUserXp(xpCap, userXp, userId) {
    const newUserXp = userXp - xpCap

    return admin.firestore().collection("Users").doc(userId).update({
        xp: newUserXp,
    })
    .then(function() {
        return newUserXp
    })
    .catch(function(error) {
        console.error("Error writing document: ", error)
    })
    
}

async function updateUserXP(currentXP, xpEarned, userId) {
    const updatedXp = currentXP + xpEarned
    return admin.firestore().collection("Users").doc(userId).update({
        xp: updatedXp,
    })
    .then(function() {
        return updatedXp
    })
    .catch(function(error) {
        console.error("Error writing document: ", error)
    })
}

// Get all workouts ordered by date (newest first)
// Limit = 5
async function getAllUserWorkouts(userId) {
    workouts = []
    return admin.firestore().collection('Users').doc(userId)
    .collection('Workouts').orderBy('date', 'desc').limit(5)
    .get()
    .then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
            workouts.push(doc.data())
        })
        return workouts
    })
    .catch(function(error) {
        console.log('Error: ',error)
    })
  }


 async function getAllWorkouts() {
   workouts = []
   return admin.firestore().collection('Workouts').get()
   .then(function(querySnapshot) {
       querySnapshot.forEach(function(doc) {
           workouts.push(doc.data())
       })
       return workouts
   })
   .catch(function(error) {
       console.log('Error: ',error)
   })
 }

// Get workout based on className
async function getWorkout2(className) {
  var workout;

  return admin.firestore().collection("Workouts").where("class", "==", className)
    .limit(1).get()
    .then(function(querySnapshot) {
      querySnapshot.forEach(function(doc) {
        workout = doc.data();
      });
      return workout;
    })
    .catch(function(error) {
      console.log("Error getting documents: ", error);
    });
}
