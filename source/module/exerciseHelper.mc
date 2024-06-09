using Toybox.Lang as Lang;

module ExerciseHelper {
  function getExerciseCount(WOI) {
    var cnt = 0;

    while (getPropertyForWorkoutExcercise(WOI, cnt + 1, false) != false) {
      cnt++;
    }

    return cnt;
  }

  function getPropertyForWorkoutExcercise(workout_number, exercise_number, default_value) {
    // var property_id = Lang.format("w$1$_e$2$_$3$", [workout_number, exercise_number, attribute_name]);
    var property_id = Lang.format("w$1$_e$2$", [workout_number, exercise_number]);
    return PropertyHelper.getProperty(property_id, default_value);
  }
}
