using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class saveWorkoutDelegate extends Ui.BehaviorDelegate {
  public function initialize() {
    BehaviorDelegate.initialize();
  }

  // This should stop the user from going back to previous view, but it does not
  // Probably a custom view is needed
  public function onBack() {
    Sys.println("BCK");
    return true;
  }
}
