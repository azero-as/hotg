var admin = require("firebase-admin");

module.exports = {
    getUserInfo: getUserInfo,
    updateUserLevelInfo: updateUserLevelInfo
}

async function getUserInfo(userId) {
    var userCollection = await getUsersCollection(userId)
    var userLevel = userCollection[0]
    var userXp = userCollection[1]
    var username = userCollection[2]

    let userLevelString = userLevel.toString()
    var xpCap = await getLevelXpCap(userLevelString)

    
    return {
        username: username,
        userLevel: userLevel,
        userXp: userXp,
        xpCap: xpCap,
    }

}


// Returns updated level info: xp, level and xp cap
async function updateUserLevelInfo(userId) {

    var userCollection = await getUsersCollection(userId)
    var userLevel = userCollection[0]
    var userXp = userCollection[1]

    let userLevelString = userLevel.toString()
    var xpCap = await getLevelXpCap(userLevelString)

    var updateLevel = await checkUpdateLevel(xpCap, userXp) //True or False
    
    if (updateLevel) {
        var newUserLevel = await increaseLevel(userLevel, userId)
        var newUserXp = await resetUserXp(xpCap, userXp, userId)

        let newUserLevelString = newUserLevel.toString()
        var newXpCap = await getLevelXpCap(newUserLevelString)

        // Update values
        var userXp = await newUserXp
        var userLevel = await newUserLevel
        var xpCap = await newXpCap
    }

    return {
        userLevel: userLevel,
        userXp: userXp,
        xpCap: xpCap,
        updateLevel: updateLevel // return True if level up
    }

}
      
async function getUsersCollection(userId) {

    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        var userLevel = querySnapshot.data().Level
        var userXp = querySnapshot.data().XP
        var username = querySnapshot.data().Username

        return [userLevel, userXp, username]
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

// Check if level needs to be updated
function checkUpdateLevel(xpCap, userXp) {

    if (userXp >= xpCap) {
        return true
    }
    else {
        console.log('ingen endring')
        return false
    
    }
}

// Increase level by 1
async function increaseLevel(userLevel, userId) {
    const newUserLevel = userLevel+1

    return admin.firestore().collection("Users").doc(userId).update({
        Level: newUserLevel,
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
        XP: newUserXp,
    })
    .then(function() {
        return newUserXp
    })
    .catch(function(error) {
        console.error("Error writing document: ", error)
    })
    
}