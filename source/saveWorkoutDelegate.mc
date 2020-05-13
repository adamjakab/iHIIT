using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class saveWorkoutDelegate extends Ui.BehaviorDelegate {
	var ctrl, workout;

	public function initialize() {
        BehaviorDelegate.initialize();
        ctrl = App.getApp().getController();
        workout = ctrl.getCurrentWorkout();
    }

    public function onBack()
    {
    	if (workout.isSaved()) {
    		ctrl.saveDone();
    	}
        return true;
    }

    public function onSelect() {
		if (workout.isSaved()) {
    		ctrl.saveDone();
    	}
        return true;
    }
}
