using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class finishWorkoutDelegate extends Ui.BehaviorDelegate {
	const MAX_OPTIONS = 2;

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onKey( keyEvent )
    {
    	var c = App.getApp().controller;
    	var k = keyEvent.getKey();
    	
    	if(k == Ui.KEY_DOWN) {
    		c.finish_workout_option++;
    		if(c.finish_workout_option > MAX_OPTIONS)
    		{
    			c.finish_workout_option = 0;
    		}
    		Ui.requestUpdate();
    	} else if (k == Ui.KEY_UP) {
    		c.finish_workout_option--;
    		if(c.finish_workout_option < 0)
    		{
    			c.finish_workout_option = MAX_OPTIONS;
    		}
    		Ui.requestUpdate();
    	} else if (k == Ui.KEY_ENTER) {
    		c.finishWorkout();
    	} else if (k == Ui.KEY_ESC) {
    		c.resume();
    	}
    	
    	return true;
    }
}

