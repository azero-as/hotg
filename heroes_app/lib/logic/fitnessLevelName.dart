// Converts fitnessLevelNumber from the database to a descriptive string.
convertFitnessLevelName(int fitnessLevel) {
  if (fitnessLevel == 3) {
    return "Advanced";
  } else if (fitnessLevel == 2) {
    return "Intermediate";
  } else {
    return "Beginner";
  }
}
