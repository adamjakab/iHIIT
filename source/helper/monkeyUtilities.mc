import Toybox.Lang;
import Toybox.System;

/* Generic helper functions */
module MonkeyUtilities {
  /* Recursive string replacement function */
  function replaceInString(input as String, search as String, replace as String) as String {
    var index = null;
    var answer = input;
    do {
      index = answer.find(search);
      if (index != null) {
        var part_1 = answer.substring(0, index);
        var part_2 = answer.substring(index + search.length(), answer.length());
        answer = part_1 + replace + part_2;
      }
    } while (index != null);

    return answer;
  }
}
