using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class doWorkoutDelegate extends Ui.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onKey(keyEvent) {
    var c = App.getApp().getController();
    var k = keyEvent.getKey();
    if (k == Ui.KEY_ENTER) {
      c.stop();
    } else if (k == Ui.KEY_ESC) {
      c.stop();
    } else {
      Sys.println(
        "Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType()
      );
    }
    return true;
  }

  function onMenu() {
    var c = App.getApp().getController();
    c.stop();
    return true;
  }
}
