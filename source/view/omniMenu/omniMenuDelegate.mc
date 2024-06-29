import Toybox.Lang;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

/**
 ** Select button callbacks will be taken from the omniMenuChoices on the controller
 ** An optional onBackCallback can be passed to the constructor for back button funcitonality
 **/
class OmniMenuDelegate extends Ui.BehaviorDelegate {
  private var ctrl as iHIITController;
  private var backButtonCallback as Method? = null;

  public function initialize(back_button_callback as Method?) {
    backButtonCallback = back_button_callback;
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
    // Sys.println("OmniMenu:+Index: " + index);
    Ui.requestUpdate();
    return true;
  }

  public function onPreviousPage() {
    var index = ctrl.omniMenuSelectedIndex - 1;
    if (index < 0) {
      index = ctrl.omniMenuChoices.size() - 1;
    }
    ctrl.omniMenuSelectedIndex = index;
    // Sys.println("OmniMenu:-Index: " + index);
    Ui.requestUpdate();
    return true;
  }

  public function onSelect() {
    var callback = getChoiceCallbackAtIndex(ctrl.omniMenuSelectedIndex);
    if (callback) {
      Sys.println("OmniMenu:Invoking callback at Index: " + ctrl.omniMenuSelectedIndex);
      callback.invoke();
    }
    // Sys.println("SFO:::No callback is defined for this option.");
    return true;
  }

  public function onBack() {
    if (backButtonCallback) {
      backButtonCallback.invoke();
    } else {
      Sys.println("OmniMenu: No back button callback was defined.");
    }

    return true;
  }

  private function getChoiceCallbackAtIndex(index as Number) as Method {
    var choice = ctrl.omniMenuChoices.get(index) as Dictionary;
    return choice.get("callback") as Method;
  }
}
