using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class discardConfirmationDelegate extends Ui.BehaviorDelegate {
  private var ctrl;

  //Init
  public function initialize() {
    BehaviorDelegate.initialize();
    ctrl = App.getApp().getController();
  }

  //Key events
  public function onKey(keyEvent) {
    var k = keyEvent.getKey();
    if (k == Ui.KEY_DOWN) {
      setNextOption();
    } else if (k == Ui.KEY_UP) {
      setPreviousOption();
    } else if (k == Ui.KEY_ENTER) {
      if (ctrl.discardConfirmationSelection == 0) {
        ctrl.discard_cancelled();
      } else {
        ctrl.discard_confirmed();
      }
    }
    Ui.requestUpdate();
    return true;
  }

  // Swipe events
  public function onSwipe(swipeEvent) {
    var dir = swipeEvent.getDirection();
    if (dir == Ui.SWIPE_DOWN) {
      setPreviousOption();
    } else if (dir == Ui.SWIPE_UP) {
      setNextOption();
    }
    Ui.requestUpdate();
    return true;
  }

  public function onTap(clickEvent) {
    if (clickEvent.getType() == Ui.CLICK_TYPE_TAP) {
      if (ctrl.discardConfirmationSelection == 0) {
        ctrl.discard_cancelled();
      } else {
        ctrl.discard_confirmed();
      }
      return true;
    }
    return false;
  }

  protected function setNextOption() {
    //Sys.println("SEL>: " + c.discardConfirmationSelection);
    ctrl.discardConfirmationSelection++;
    if (ctrl.discardConfirmationSelection > 1) {
      ctrl.discardConfirmationSelection = 0;
    }
  }

  protected function setPreviousOption() {
    //Sys.println("SEL<: " + c.discardConfirmationSelection);
    ctrl.discardConfirmationSelection--;
    if (ctrl.discardConfirmationSelection < 0) {
      ctrl.discardConfirmationSelection = 1;
    }
  }

  //Menu handling
  public function onMenu() {
    return false;
  }
}
