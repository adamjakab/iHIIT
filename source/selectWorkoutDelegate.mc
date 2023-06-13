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
    	ctrl.setNextWorkout();
    	Ui.requestUpdate();
        return true;
    }

    public function onPreviousPage() {
    	ctrl.setPreviousWorkout();
    	Ui.requestUpdate();
        return true;
    }

    public function onSelect() {
    	ctrl.beginCurrentWorkout();
        return true;
    }

    public function onBack() {
    	if (App.getApp().isDebugMode()) {
    		Sys.println("Debug mode: Not exiting!");
        	return true;
    	}
    	return false;
    }

    public function onMenu() {
        return true;
    }
}
