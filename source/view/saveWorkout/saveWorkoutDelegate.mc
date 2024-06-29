using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class SaveWorkoutDelegate extends Ui.BehaviorDelegate {
  private var ctrl, currentWorkout;

  public function initialize() {
    BehaviorDelegate.initialize();
    ctrl = App.getApp().getController();
    currentWorkout = ctrl.getCurrentWorkout();
  }

  public function onBack() {
    if (currentWorkout.isSaved()) {
      ctrl.saveWorkoutDone();
    }
    return true;
  }

  public function onSelect() {
    if (currentWorkout.isSaved()) {
      ctrl.saveWorkoutDone();
    }
    return true;
  }
}
