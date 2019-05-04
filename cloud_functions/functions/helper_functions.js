var admin = require("firebase-admin");

module.exports = {
    getUserInfo: getUserInfo,
    getCompletedUserWorkouts: getCompletedUserWorkouts,
    getRecommendedWorkout: getRecommendedWorkout,
    getAllWorkouts: getAllWorkouts,
    updateUserLevelInfo: updateUserLevelInfo,
    updateUserXp: updateUserXp,
}

// Get user info from Users collection, email and xpCap based on current gameLevel
async function getUserInfo(userId, email) {

    // Array from getUserCollection
    var userCollection = await getUsersCollection(userId)
    var gameLevel = userCollection[0]
    var userXp = userCollection[1]
    var characterName = userCollection[2]
    var className = userCollection[3]
    var fitnessLevel = userCollection[4]

    let gameLevelString = gameLevel.toString()
    var xpCap = await getLevelXpCap(gameLevelString)

    return {
        characterName: characterName,
        gameLevel: gameLevel,
        userXp: userXp,
        xpCap: xpCap,
        className: className,
        email: email,
        fitnessLevel: fitnessLevel
    }
}

// Updates and returns updated level info: xp, gameLevel and xpCap
async function updateUserLevelInfo(userId, userXp, xpCap, gameLevel) {

    var newGameLevel = await increaseLevel(gameLevel, userId)
    var newUserXp = await resetUserXp(xpCap, userXp, userId)

    let newGameLevelString = newGameLevel.toString()
    var newXpCap = await getLevelXpCap(newGameLevelString)

    // Updated values
    var userXp = await newUserXp
    var gameLevel = await newGameLevel
    var xpCap = await newXpCap

    return {
        gameLevel: gameLevel,
        userXp: userXp,
        xpCap: xpCap,
    }
}

// Updates xp in User collection with xpEarned from finishing a workout
async function updateUserXp(userId, xpEarned) {
    var userCollection = await getUsersCollection(userId)
    var currentXp = userCollection[1]
    var updatedXp = await increaseXp(currentXp, xpEarned, userId)

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
            var fitnessLevel = querySnapshot.data().fitnessLevel

            return [gameLevel, userXp, characterName, className, fitnessLevel]
        })
        .catch(function (error) {
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
            const levelXpCap = querySnapshot.data().xpCap
            return levelXpCap;
        })
        .catch(function (error) {
            console.log('Error getting data from Levels collection. ', error)
        })
        .catch(function (error) {
            console.log("Error: ", error)
        })
}

// Increase gameLevel by 1
async function increaseLevel(gameLevel, userId) {
    const newGameLevel = gameLevel + 1
    return admin.firestore().collection("Users").doc(userId).update({
        gameLevel: newGameLevel,
    })
        .then(function () {
            return newGameLevel
        })
        .catch(function (error) {
            console.error("Error writing document: ", error)
        })
}

// Reset xp values for User collection when leveling up
async function resetUserXp(xpCap, userXp, userId) {
    const newUserXp = userXp - xpCap

    return admin.firestore().collection("Users").doc(userId).update({
        xp: newUserXp,
    })
        .then(function () {
            return newUserXp
        })
        .catch(function (error) {
            console.error("Error writing document: ", error)
        })
}

// Increse xp in Users collection and returns new value
async function increaseXp(currentXp, xpEarned, userId) {
    const updatedXp = currentXp + xpEarned

    return admin
        .firestore()
        .collection("Users")
        .doc(userId)
        .update({
            xp: updatedXp,
        })
        .then(function () {
            return updatedXp
        })
        .catch(function (error) {
            console.error("Error writing document: ", error)
        })
}

// Get 10 last workouts from the User collection, ordered by date
async function getCompletedUserWorkouts(userId) {
    workouts = []
    return admin.firestore()
        .collection('Users')
        .doc(userId)
        .collection('Workouts')
        .orderBy('date', 'desc')
        .limit(10)
        .get()
        .then(function (querySnapshot) {
            querySnapshot.forEach(function (doc) {
                workouts.push(doc.data())
            })
            return workouts
        })
        .catch(function (error) {
            console.log('Error getting workouts from Users collection ', error)
        })
}

// Get all workouts as a list from Workouts collection
async function getAllWorkouts() {
    workouts = []
    return admin.firestore()
        .collection('Workouts')
        .get()
        .then(function (querySnapshot) {
            querySnapshot.forEach(function (doc) {
                workouts.push(doc.data())
            })
            return workouts
        })
        .catch(function (error) {
            console.log('Error getting workout. ', error)
        })
}

// Get a random recommended workout based on className
async function getRecommendedWorkout(className) {

    var workoutList = []

    return admin.firestore()
        .collection("Workouts")
        .where("class", "==", className)
        .get()
        .then(function (querySnapshot) {
            querySnapshot.forEach(function (doc) {
                workoutList.push(doc.data())
            })

            randomWorkout = Math.floor(Math.random() * workoutList.length);

            return workoutList[randomWorkout]
        })
        .catch(function (error) {
            console.log("Error getting workout. ", error);
        })
}
