using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class doWorkoutDelegate extends Ui.BehaviorDelegate {
	private var ctrl;

    function initialize() {
        BehaviorDelegate.initialize();
        ctrl = App.getApp().getController();
    }

    public function onNextPage() {
        return true;
    }

    public function onPreviousPage() {
        return true;
    }

    public function onSelect() {
    	ctrl.stop();
        return true;
    }

    public function onBack() {
    	ctrl.stop();
    	return true;
    }

    public function onMenu() {
        return true;
    }
}

