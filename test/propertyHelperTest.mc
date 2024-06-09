import Toybox.Test;
import Toybox.Lang;

var prop_map_workout_1 = {
  "workout_1" => {
    "title" => "Full Body",
    "enabled" => true,
  },
  "workout_2" => {
    "title" => "Abs",
    "enabled" => true,
  },
};

(:test)
function stringPropertyTest(logger as Logger) as Boolean {
  var actual = PropertyHelper.getProperty("w1_title", "");
  var expected = "Workout 1";
  Test.assert(actual instanceof Lang.String);
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "' to be equal to: '" + expected + "'.");
  return true;
}

(:test)
function booleanPropertyTest(logger as Logger) as Boolean {
  var actual = PropertyHelper.getProperty("w1_enabled", false);
  var expected = true;
  Test.assert(actual instanceof Lang.Boolean);
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "' to be equal to: '" + expected + "'.");
  return true;
}

(:test)
function numericPropertyTest(logger as Logger) as Boolean {
  var actual = PropertyHelper.getProperty("w1_exercise_duration", 1);
  var expected = 40;
  Test.assert(actual instanceof Lang.Number);
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "' to be equal to: '" + expected + "'.");
  return true;
}

(:test)
function missingPropertyTest(logger as Logger) as Boolean {
  var actual = PropertyHelper.getProperty("I_AM_NOT_HERE", true);
  var expected = true;
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "' to be equal to: '" + expected + "'.");
  return true;
}

(:test)
function emptyStringPropertyTest(logger as Logger) as Boolean {
  var actual = PropertyHelper.getProperty("workout_5_exercise_20_title", "DEFAULT");
  var expected = "DEFAULT";
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "' to be equal to: '" + expected + "'.");
  return true;
}
