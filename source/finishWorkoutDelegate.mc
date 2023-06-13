using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class finishWorkoutDelegate extends Ui.BehaviorDelegate {
	private var ctrl;
	private var select_items;
	private var max_items = 3;
	private var current_key = 0;
	private var item_keys = [];


    public function initialize() {
        BehaviorDelegate.initialize();

        ctrl = App.getApp().getController();
        var currentWorkout = ctrl.getCurrentWorkout();

        select_items = ApeTools.AppHelper.getDiscardOptions(currentWorkout.isTerminated());
    	max_items = select_items.size();
    	item_keys = select_items.keys();
    	current_key = 0;
        ctrl.finish_workout_option = item_keys[current_key];
    }

    public function onKey( keyEvent )
    {
    	var currentWorkout = ctrl.getCurrentWorkout();

    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		setNextOption();
    	} else if (k == Ui.KEY_UP) {
    		setPreviousOption();
    	} else if (k == Ui.KEY_ENTER) {
    		ctrl.finishWorkout();
    	} else if (k == Ui.KEY_ESC) {
    		if(!currentWorkout.isTerminated())
    		{
    			ctrl.resume();
    		}
    	}

    	return true;
    }

    // Swipe events
    public function onSwipe( swipeEvent )
    {
    	var dir = swipeEvent.getDirection();
    	if (dir == Ui.SWIPE_DOWN) {
    		setPreviousOption();
    	} else if (dir == Ui.SWIPE_UP) {
    		setNextOption();
    	}
    }

    public function onTap(clickEvent)
    {
    	if (clickEvent.getType() == Ui.CLICK_TYPE_TAP)
    	{
    		ctrl.finishWorkout();
    	}
    }

    private function setNextOption()
    {
    	current_key++;
		if(current_key > (max_items - 1))
		{
			current_key = 0;
		}
		ctrl.finish_workout_option = item_keys[current_key];
		Ui.requestUpdate();
    }

    private function setPreviousOption()
    {
    	current_key--;
		if(current_key < 0)
		{
			current_key = (max_items - 1);
		}
		ctrl.finish_workout_option = item_keys[current_key];
		Ui.requestUpdate();
    }

    //Menu handling
    public function onMenu() {
        return false;
    }
}

