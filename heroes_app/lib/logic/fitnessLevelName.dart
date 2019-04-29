// Converts classes to either Paladin or Ranger workouts
convertFitnessLevelName(int fitnessLevel) {
  if (fitnessLevel == 3) {
    return "advanced";
  } else if (fitnessLevel == 2) {
    return "intermediate";
  } else {
    return "beginner";
  }
}
