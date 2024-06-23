import Toybox.Lang;

module WorkoutHelper {
  // Checks if workout is enabled, has title and has at least one exercise
  public function isSelectableWorkout(workout_number as Number) as Boolean {
    var answer = false;
    if (getPropertyForWorkout(workout_number, "title", false) != false) {
      if (getPropertyForWorkout(workout_number, "enabled", false) == true) {
        if (ExerciseHelper.getExerciseCount(workout_number) > 0) {
          answer = true;
        }
      }
    }

    return answer;
  }

  /**
   * Gets a workout property
   **/
  public function getPropertyForWorkout(
    workout_number,
    attribute_name,
    default_value
  ) {
    var property_id = Lang.format("w$1$_$2$", [workout_number, attribute_name]);
    return PropertyHelper.getProperty(property_id, default_value);
  }
}
