using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

/**
	Key constants: https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi.html
 **/
class selectWorkoutDelegate extends Ui.BehaviorDelegate {
  protected var ctrl;
  protected var WOI = null;

  // Init
  public function initialize() {
    ctrl = App.getApp().getController();
    BehaviorDelegate.initialize();
  }

  // Key events
  public function onKey(keyEvent) {
    var k = keyEvent.getKey();
    if (k == Ui.KEY_DOWN) {
      WOI = ctrl.setNextWorkout();
      updateAfterAction(WOI);
      return true;
    } else if (k == Ui.KEY_UP) {
      WOI = ctrl.setPreviousWorkout();
      updateAfterAction(WOI);
      return true;
    } else if (k == Ui.KEY_ENTER) {
      ctrl.beginCurrentWorkout();
      return true;
    }
    return false;
  }

  // Swipe events
  public function onSwipe(swipeEvent) {
    var dir = swipeEvent.getDirection();
    if (dir == Ui.SWIPE_DOWN) {
      WOI = ctrl.setNextWorkout();
      updateAfterAction(WOI);
      return true;
    } else if (dir == Ui.SWIPE_UP) {
      WOI = ctrl.setPreviousWorkout();
      updateAfterAction(WOI);
      return true;
    }
    return false;
  }

  public function onTap(clickEvent) {
    if (clickEvent.getType() == Ui.CLICK_TYPE_TAP) {
      ctrl.beginCurrentWorkout();
      return true;
    }
    return false;
  }

  protected function updateAfterAction(WOI) {
    if (WOI != null) {
      var workout = ctrl.getCurrentWorkout();
      Sys.println(
        "NEW WORKOUT SET(" +
          workout.getWorkoutIndex() +
          "): " +
          workout.getTitle()
      );
      Ui.requestUpdate();
    }
  }

  //Menu handling
  public function onMenu() {
    return false;
  }
}
