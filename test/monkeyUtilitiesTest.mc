import Toybox.Test;
import Toybox.Lang;

(:test)
function replaceInStringTest(logger as Logger) as Boolean {
  Test.assertEqual(MonkeyUtilities.replaceInString("workout_1_title", "1", "X"), "workout_X_title");
  Test.assertEqual(MonkeyUtilities.replaceInString("workout_1_title_1", "1", "X"), "workout_X_title_X");
  Test.assertEqual(MonkeyUtilities.replaceInString("1_workout_1_title_1", "1", "X"), "X_workout_X_title_X");
  Test.assertEqual(MonkeyUtilities.replaceInString("workout_1_title", "workout_1", "w1"), "w1_title");
  Test.assertEqual(MonkeyUtilities.replaceInString("w1_title", "w1", "workout_1"), "workout_1_title");
  return true;
}
