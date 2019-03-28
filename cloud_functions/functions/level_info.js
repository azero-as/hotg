
var admin = require("firebase-admin");

var serviceAccount = require("./minkey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://heroes-6fe69.firebaseio.com"
});

const userId = '0EWvvdAUc2QEJn6ChySZU0iTXmF2';

getLevelInfo(userId)
.then( (levelInfo) => {
    console.log(levelInfo)
})
.catch(error => {
    console.log(error)
})

// Returns updated level info (xp, level and xp cap)
async function getLevelInfo(userId) {

    var userLevel = await getUserLevel(userId)
    let userLevelString = userLevel.toString()
    var xpCap = await getXpCap(userLevelString)
    var userXp = await getUserXp(userId)

    var updateLevel = await checkUpdateLevel(xpCap, userXp) //True or False
    
    if (updateLevel) {
        var newUserLevel = await increaseLevel(userLevel)
        var newUserXp = await resetUserXp(xpCap, userXp)

        let newUserLevelString = newUserLevel.toString()
        var newXpCap = await getXpCap(newUserLevelString)

        // Update values
        var userXp = await newUserXp
        var userLevel = await newUserLevel
        var xpCap = await newXpCap
    }

    return {
        Level: userLevel,
        XP: userXp,
        xpCap: xpCap,
    }

}

// get current user level 
async function getUserLevel(userId) {

    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        const userLevel = querySnapshot.data().Level
        return userLevel
    })
    .catch(function(error) {
        console.log('Error: ', error)
    })
}

// Get current user xp 
async function getUserXp(userId) {
    return admin.firestore().collection('Users').doc(userId).get()
    .then(querySnapshot => {
        const userXp = querySnapshot.data().XP
        return userXp
    })
    .catch(function(error) {
        console.log('Error:', error)
    })
}

// Get xp cap for current user level 
async function getXpCap(userLevel) {
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
async function increaseLevel(userLevel) {
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
async function resetUserXp(xpCap, userXp) {
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
