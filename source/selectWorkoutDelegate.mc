using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class selectWorkoutDelegate extends Ui.BehaviorDelegate {
	//Init
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    //Key events
    public function onKey( keyEvent )
    {
    	var c = App.getApp().getController();
    	var WOI = null;
    	
    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		WOI = c.setNextWorkout();
    	} else if (k == Ui.KEY_UP) {
    		WOI = c.setPreviousWorkout();
    	} else if (k == Ui.KEY_ENTER) {
    		 c.beginCurrentWorkout();
    	} else {
    		//Sys.println("Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType());
    	}
    	
    	if (WOI != null)
    	{
    		var workout = c.getCurrentWorkout();
    		Sys.println("NEW WORKOUT SET(" + workout.getWorkoutIndex() + "): " + workout.getTitle());
    		Ui.requestUpdate();
    	}
    }

	//Menu handling
    public function onMenu() {
        return false;
    }
}