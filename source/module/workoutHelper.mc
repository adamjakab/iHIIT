// using Toybox.System as Sys;
using Toybox.Lang as Lang;
// using Toybox.WatchUi as Ui;
// using Toybox.Graphics as Gfx;

module WorkoutHelper {
  // DO NOT USE THIS
  // public function getWorkoutCount()
  // {
  // 	var cnt = 0;

  // 	while(getPropertyForWorkout((cnt+1), "title", false) != false)
  // 	{
  // 		cnt++;
  // 	}

  // 	return cnt;
  // }

  // Checks: title, enabled, at least one exercise
  public function isSelectableWorkout(workout_number) {
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

  public function getPropertyForWorkout(workout_number, attribute_name, default_value) {
    var property_id = Lang.format("workout_$1$_$2$", [workout_number, attribute_name]);
    return PropertyHelper.getProperty(property_id, default_value);
  }
}
