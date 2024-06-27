// using Toybox.WatchUi as Ui;
// using Toybox.System as Sys;
// using Toybox.Application as App;

// class DiscardConfirmationDelegate extends Ui.BehaviorDelegate {
//   private var ctrl;

//   //Init
//   public function initialize() {
//     BehaviorDelegate.initialize();
//     ctrl = App.getApp().getController();
//   }

//   public function onNextPage() {
//     setNextOption();
//     Ui.requestUpdate();
//     return true;
//   }

//   public function onPreviousPage() {
//     setPreviousOption();
//     Ui.requestUpdate();
//     return true;
//   }

//   public function onSelect() {
//     if (ctrl.discardConfirmationSelection == 0) {
//       ctrl.discard_cancelled();
//     } else {
//       ctrl.discard_confirmed();
//     }
//     return true;
//   }

//   public function onBack() {
//     return true;
//   }

//   public function onMenu() {
//     return true;
//   }

//   protected function setNextOption() {
//     //Sys.println("SEL>: " + c.discardConfirmationSelection);
//     ctrl.discardConfirmationSelection++;
//     if (ctrl.discardConfirmationSelection > 1) {
//       ctrl.discardConfirmationSelection = 0;
//     }
//   }

//   protected function setPreviousOption() {
//     //Sys.println("SEL<: " + c.discardConfirmationSelection);
//     ctrl.discardConfirmationSelection--;
//     if (ctrl.discardConfirmationSelection < 0) {
//       ctrl.discardConfirmationSelection = 1;
//     }
//   }
// }
