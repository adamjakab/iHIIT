import Toybox.Test;
import Toybox.Lang;

(:test)
function testEquality(logger as Logger) as Boolean {
  var x = 1;
  var y = 1;
  return x == y;
}

(:test)
function testBigger(logger as Logger) as Boolean {
  var x = 1;
  var y = 2;
  return x < y;
}
