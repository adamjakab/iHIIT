using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class finishWorkoutDelegate extends Ui.BehaviorDelegate {
	private var select_items;
	private var max_items = 3;
	private var current_key = 0;
	private var item_keys = [];
	

    function initialize() {
        BehaviorDelegate.initialize();
        
        var c = App.getApp().getController();
        var currentWorkout = c.getCurrentWorkout();

        select_items = ApeTools.AppHelper.getDiscardOptions(currentWorkout.isTerminated());
    	max_items = select_items.size();
    	item_keys = select_items.keys();
    	current_key = 0;
        c.finish_workout_option = item_keys[current_key];
    }
    
    function onKey( keyEvent )
    {
    	var c = App.getApp().getController();
    	var currentWorkout = c.getCurrentWorkout();
    	
    	var k = keyEvent.getKey();    	
    	if(k == Ui.KEY_DOWN) {
    		current_key++;
    		if(current_key > (max_items - 1))
    		{
    			current_key = 0;
    		}
    		c.finish_workout_option = item_keys[current_key];
    		Ui.requestUpdate();
    	} else if (k == Ui.KEY_UP) {
    		current_key--;
    		if(current_key < 0)
    		{
    			current_key = (max_items - 1);
    		}
    		c.finish_workout_option = item_keys[current_key];
    		Ui.requestUpdate();
    	} else if (k == Ui.KEY_ENTER) {
    		c.finishWorkout();
    	} else if (k == Ui.KEY_ESC) {
    		if(!currentWorkout.isTerminated())
    		{
    			c.resume();
    		}
    	}
    	
    	return true;
    }
}

