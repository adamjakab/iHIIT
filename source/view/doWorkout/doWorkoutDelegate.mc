using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class DoWorkoutDelegate extends Ui.BehaviorDelegate {
  private var ctrl as iHIITController;

  function initialize() {
    BehaviorDelegate.initialize();
    ctrl = App.getApp().getController();
  }

  public function onNextPage() {
    return true;
  }

  public function onPreviousPage() {
    return true;
  }

  public function onSelect() {
    ctrl.stopWorkout();
    return true;
  }

  public function onBack() {
    ctrl.stopWorkout();
    return true;
  }

  public function onMenu() {
    return true;
  }
}
