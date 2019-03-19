var admin = require("firebase-admin");

module.exports = {
    getUserInfo: getUserInfo
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
      
// Get current user level, xp and username from "Users" collection
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
