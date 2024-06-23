using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class finishWorkoutDelegate extends Ui.BehaviorDelegate {
  private var ctrl, workout;

  private var select_items;
  private var max_items = 3;
  private var current_key = 0;
  private var item_keys = [];

  public function initialize() {
    BehaviorDelegate.initialize();
    ctrl = App.getApp().getController();
    workout = ctrl.getCurrentWorkout();

    select_items = ApeTools.AppHelper.getDiscardOptions(workout.isTerminated());
    max_items = select_items.size();
    item_keys = select_items.keys();
    current_key = 0;
    ctrl.finish_workout_option = item_keys[current_key];
  }

  public function onNextPage() {
    setNextOption();
    return true;
  }

  public function onPreviousPage() {
    setPreviousOption();
    return true;
  }

  public function onSelect() {
    ctrl.finishWorkout();
    return true;
  }

  public function onBack() {
    if (!workout.isTerminated()) {
      ctrl.resume();
    }
    return true;
  }

  public function onMenu() {
    return true;
  }

  private function setNextOption() {
    current_key++;
    if (current_key > max_items - 1) {
      current_key = 0;
    }
    ctrl.finish_workout_option = item_keys[current_key];
    Ui.requestUpdate();
  }

  private function setPreviousOption() {
    current_key--;
    if (current_key < 0) {
      current_key = max_items - 1;
    }
    ctrl.finish_workout_option = item_keys[current_key];
    Ui.requestUpdate();
  }
}
