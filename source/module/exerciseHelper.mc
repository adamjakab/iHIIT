// using Toybox.System as Sys;
using Toybox.Lang as Lang;
// using Toybox.WatchUi as Ui;
// using Toybox.Graphics as Gfx;

module ExerciseHelper {
  function getExerciseCount(WOI) {
    var cnt = 0;

    while (getPropertyForWorkoutExcercise(WOI, cnt + 1, "title", false) != false) {
      cnt++;
    }

    return cnt;
  }

  function getPropertyForWorkoutExcercise(workout_number, exercise_number, attribute_name, default_value) {
    var property_id = Lang.format("workout_$1$_exercise_$2$_$3$", [workout_number, exercise_number, attribute_name]);
    return PropertyHelper.getProperty(property_id, default_value);
  }
}
