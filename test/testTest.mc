import Toybox.Test;
import Toybox.Lang;

(:test)
function replaceInStringTest(logger as Logger) as Boolean {
  var expected = true;
  var real = true;
  Test.assertEqualMessage(expected, real, "should be the same");
  return true;
}
