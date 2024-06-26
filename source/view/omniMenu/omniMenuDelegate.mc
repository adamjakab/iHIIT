using Toybox.Application as App;
using Toybox.System as Sys;
import Toybox.Lang;
using Toybox.WatchUi as Ui;

class OmniMenuDelegate extends Ui.BehaviorDelegate {
  private var ctrl as iHIITController;

  public function initialize() {
    BehaviorDelegate.initialize();
    ctrl = App.getApp().getController();
  }

  public function onNextPage() {
    var max = ctrl.omniMenuChoices.size();
    var index = ctrl.omniMenuSelectedIndex + 1;
    if (index >= max) {
      index = 0;
    }
    ctrl.omniMenuSelectedIndex = index;
    Sys.println("SFO:::+Index: " + index);
    Ui.requestUpdate();
    return true;
  }

  public function onPreviousPage() {
    var index = ctrl.omniMenuSelectedIndex - 1;
    if (index < 0) {
      index = ctrl.omniMenuChoices.size() - 1;
    }
    ctrl.omniMenuSelectedIndex = index;
    Sys.println("SFO:::-Index: " + index);
    Ui.requestUpdate();
    return true;
  }

  public function onSelect() {
    var callback = getChoiceCallbackAtIndex(ctrl.omniMenuSelectedIndex);
    if (callback) {
      callback.invoke();
      return true;
    }
    Sys.println("SFO:::No callback is defined for this option.");
    return false;
  }

  public function onBack() {
    Sys.println("SFO:::BACK-1");
    return true;
  }

  private function getChoiceCallbackAtIndex(index as Number) as Method {
    var choice = ctrl.omniMenuChoices.get(index) as Dictionary;
    return choice.get("callback") as Method;
  }
}
