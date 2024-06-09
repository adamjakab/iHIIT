using Toybox.Application as App;
import Toybox.Lang;
import Toybox.System;

module PropertyHelper {
  function getProperty(property_id, default_value) {
    var property_value = App.getApp().getProperty(property_id);

    if (property_value == null || (property_value instanceof String && property_value.length() == 0)) {
      property_value = default_value;
    }
    //Sys.println("Got property(" + property_id + ") value: " + property_value);

    return property_value;
  }

  /**
   * From Version 2 the property names are being changed (shortened)
   */
  function mapNewNameToOldName(property_id as String) as String {
    var answer = property_id;
    answer = MonkeyUtilities.replaceInString(answer, "w1", "workout_1");
    answer = MonkeyUtilities.replaceInString(answer, "w2", "workout_2");
    answer = MonkeyUtilities.replaceInString(answer, "w3", "workout_3");
    answer = MonkeyUtilities.replaceInString(answer, "w4", "workout_4");
    answer = MonkeyUtilities.replaceInString(answer, "w5", "workout_5");
    answer = MonkeyUtilities.replaceInString(answer, "_e1", "_exercise_1_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e2", "_exercise_2_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e3", "_exercise_3_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e4", "_exercise_4_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e5", "_exercise_5_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e6", "_exercise_6_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e7", "_exercise_7_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e8", "_exercise_8_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e9", "_exercise_9_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e10", "_exercise_10_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e11", "_exercise_11_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e12", "_exercise_12_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e13", "_exercise_13_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e14", "_exercise_14_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e15", "_exercise_15_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e16", "_exercise_16_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e17", "_exercise_17_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e18", "_exercise_18_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e19", "_exercise_19_title");
    answer = MonkeyUtilities.replaceInString(answer, "_e20", "_exercise_20_title");

    return answer;
  }
}
