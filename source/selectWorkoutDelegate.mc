using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;


class selectWorkoutDelegate extends Ui.BehaviorDelegate {
	private var ctrl;

    public function initialize() {
    	ctrl = App.getApp().getController();
        BehaviorDelegate.initialize();
    }

    public function onNextPage() {
    	var WOI = ctrl.setNextWorkout();
    	updateAfterAction(WOI);
        return true;
    }

    public function onPreviousPage() {
    	var WOI = ctrl.setPreviousWorkout();
    	updateAfterAction(WOI);
        return true;
    }

    public function onSelect() {
    	ctrl.beginCurrentWorkout();
        return true;
    }

	// todo: this needs to return false
    public function onBack() {
    	Sys.println("Back pressed");
        return true;
    }

    public function onMenu() {
    	Sys.println("Menu pressed");
        return true;
    }

    private function updateAfterAction(WOI)
    {
    	if (WOI != null)
    	{
    		var workout = ctrl.getCurrentWorkout();
    		Sys.println("WORKOUT(" + workout.getWorkoutIndex() + ") SET TO: " + workout.getTitle());
    		Ui.requestUpdate();
    	}
    }
}
