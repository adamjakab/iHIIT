using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class TestModeDelegate extends Ui.BehaviorDelegate {
  private var ctrl;

  public function initialize() {
    ctrl = App.getApp().getController();
    BehaviorDelegate.initialize();
  }

  public function onNextPage() {
    ctrl.testModeNextScreen();
    Ui.requestUpdate();
    return true;
  }

  public function onPreviousPage() {
    ctrl.testModePreviousScreen();
    Ui.requestUpdate();
    return true;
  }

  public function onSelect() {
    return true;
  }

  public function onBack() {
    Sys.println("Test mode: Not exiting!");
    return true;
  }

  public function onMenu() {
    return true;
  }
}
