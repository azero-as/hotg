// Converts classes to either Paladin or Ranger workouts
convertFitnessLevelName(int fitnessLevel) {
  if (fitnessLevel == 3) {
    return "Advanced";
  } else if (fitnessLevel == 2) {
    return "Intermediate";
  } else {
    return "Beginner";
  }
}
