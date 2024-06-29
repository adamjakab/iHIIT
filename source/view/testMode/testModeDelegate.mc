using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class TestModeDelegate extends Ui.BehaviorDelegate {
  private var ctrl;

  public function initialize() {
    ctrl = App.getApp().getController();
    BehaviorDelegate.initialize();
  }

  (:debug)
  public function onNextPage() {
    ctrl.testModeNextScreen();
    Ui.requestUpdate();
    return true;
  }

  (:debug)
  public function onPreviousPage() {
    ctrl.testModePreviousScreen();
    Ui.requestUpdate();
    return true;
  }

  (:debug)
  public function onSelect() {
    return true;
  }

  (:debug)
  public function onBack() {
    Sys.println("Test mode: Not exiting!");
    return true;
  }

  (:debug)
  public function onMenu() {
    return true;
  }
}
