using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class selectWorkoutDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onKey( keyEvent )
    {
    	var c = App.getApp().getController();
    	var m = c.getModel();
    	var WOI = null;
    	
    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		WOI = m.setNextWorkout();
    	} else if (k == Ui.KEY_UP) {
    		WOI = m.setPreviousWorkout();
    	} else if (k == Ui.KEY_ENTER) {
    		 c.start();
    	} else {
    		//Sys.println("Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType());
    	}
    	
    	if (WOI != null)
    	{
    		Sys.println("NEW WORKOUT SET(" + WOI + "): " + m.getCurrentWorkoutName());
    		Ui.requestUpdate();
    	}
    }

    function onMenu() {
        //Ui.pushView(new Rez.Menus.MainMenu(), new iqMenuDelegate(), Ui.SLIDE_UP);
        return false;
    }

}