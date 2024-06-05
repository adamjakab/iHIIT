import Toybox.Test;
import Toybox.Lang;

(:test)
function testMyToolsModule(logger as Logger) as Boolean {
  var actual = TestModule.getProperty();
  var expected = "XYZ";
  Test.assertEqualMessage(actual, expected, "Expected '" + actual + "'' to be equal to: '" + expected + "'.");
  return true;
}
