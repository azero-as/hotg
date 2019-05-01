// Converts classes to either Paladin or Ranger workouts
convertClassName(String className) {
  if (className == "Barbarian" ||
      className == "Paladin" ||
      className == "Fighter") {
    return "Paladin";
  } else if (className == "Ranger" ||
      className == "Monk" ||
      className == "Rogue") {
    return "Ranger";
  } else {
    return "Ranger";
  }
}


