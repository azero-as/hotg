var admin = require("firebase-admin");

module.exports = {
  getUserInfo: getUserInfo,
  getAllUserWorkouts: getAllUserWorkouts,
  getWorkout2: getWorkout2,
  getAllWorkouts: getAllWorkouts
};

// Get level, xp, username, class and email from logged in user
async function getUserInfo(userId, email) {
  var userCollection = await getUsersCollection(userId);
  var userLevel = userCollection[0];
  var userXp = userCollection[1];
  var username = userCollection[2];
  var className = userCollection[3];

  let userLevelString = userLevel.toString();
  var xpCap = await getLevelXpCap(userLevelString);

  return {
    username: username,
    userLevel: userLevel,
    userXp: userXp,
    xpCap: xpCap,
    className: className,
    email: email
  };
}

// Get current user level, xp, charactername and class from "Users" collection
async function getUsersCollection(userId) {
  return admin
    .firestore()
    .collection("Users")
    .doc(userId)
    .get()
    .then(querySnapshot => {
      var userLevel = querySnapshot.data().gameLevel;
      var userXp = querySnapshot.data().xp;
      var username = querySnapshot.data().characterName;
      var className = querySnapshot.data().class;

      return [userLevel, userXp, username, className];
    })
    .catch(function(error) {
      console.log("Error: ", error);
    });
}

// Get xp cap for current user level from "Levels" collection
async function getLevelXpCap(userLevel) {
  return admin
    .firestore()
    .collection("Levels")
    .doc(userLevel)
    .get()
    .then(querySnapshot => {
      const levelXpCap = querySnapshot.data().xpCap;
      return levelXpCap;
    })
    .catch(function(error) {
      console.log("Error:", error);
    });
}

// Get all workouts ordered by date (newest first)
// Limit = 5
async function getAllUserWorkouts(userId) {
  workouts = [];
  return admin
    .firestore()
    .collection("Users")
    .doc(userId)
    .collection("Workouts")
    .orderBy("date", "desc")
    .limit(5)
    .get()
    .then(function(querySnapshot) {
      querySnapshot.forEach(function(doc) {
        workouts.push(doc.data());
      });
      return workouts;
    })
    .catch(function(error) {
      console.log("Error: ", error);
    });
}

async function getAllWorkouts() {
  workouts = [];
  return admin
    .firestore()
    .collection("Workouts")
    .get()
    .then(function(querySnapshot) {
      querySnapshot.forEach(function(doc) {
        workouts.push(doc.data());
      });
      return workouts;
    })
    .catch(function(error) {
      console.log("Error: ", error);
    });
}

// Get workout based on className
async function getWorkout2(className) {
  var workout;
  return admin
    .firestore()
    .collection("Workouts")
    .where("class", "==", className)
    .limit(1)
    .get()
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
