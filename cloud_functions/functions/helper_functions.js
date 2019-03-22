var admin = require("firebase-admin");

module.exports = {
    getUserInfo: getUserInfo,
    updateUserLevelInfo: updateUserLevelInfo,
    updateUserXpWorkout: updateUserXpWorkout,
    getAllUserWorkouts: getAllUserWorkouts
}

async function getUserInfo(userId) {
    var userCollection = await getUsersCollection(userId)
    var userLevel = userCollection[0]
    var userXp = userCollection[1]
    var username = userCollection[2]
    var className = userCollection[3]

    let userLevelString = userLevel.toString()
    var xpCap = await getLevelXpCap(userLevelString)

    
    return {
        username: username,
        userLevel: userLevel,
        userXp: userXp,
        xpCap: xpCap,
        className: className
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
// Update user xp with totalWorkoutXP

async function updateUserXpWorkout(userId, totalWorkoutXp) {
    var userCollection = await getUsersCollection(userId)
    var currentXp = userCollection[1]
    var updatedXp = await updateUserXP(currentXp, totalWorkoutXp, userId)

    return {
        updatedXp: updatedXp // New XP
    }
}
      
// Get current user level, xp, charactername and class from "Users" collection
async function getUsersCollection(userId) {

    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        var userLevel = querySnapshot.data().gameLevel
        var userXp = querySnapshot.data().xp
        var username = querySnapshot.data().characterName
        var className = querySnapshot.data().class

        return [userLevel, userXp, username, className]
    })
    .catch(function(error) {
        console.log('Error: ', error)
    })
}


// Get xp cap for current user level from "Levels" collection
async function getLevelXpCap(userLevel) {
    return admin.firestore().collection('Levels').doc(userLevel).get()
    .then(querySnapshot => {
        const levelXpCap = querySnapshot.data().xpCap
        return levelXpCap
    })
    .catch(function(error) {
        console.log('Error:', error)
    })
}


/* // Check if level needs to be updated
function checkUpdateLevel(xpCap, userXp) {

    if (userXp >= xpCap) {
        return true
    }
    else {
        console.log('ingen endring')
        return false
    
    }
}
*/

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

async function updateUserXP(currentXP, totalWorkoutXp, userId) {
    const updatedXp = currentXP + totalWorkoutXp
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


