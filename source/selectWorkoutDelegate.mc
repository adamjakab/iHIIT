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
    	var m;
    	var WOI = null;
    	
    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		WOI = c.setNextWorkout();
    	} else if (k == Ui.KEY_UP) {
    		WOI = c.setPreviousWorkout();
    	} else if (k == Ui.KEY_ENTER) {
    		 c.start();
    	} else {
    		//Sys.println("Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType());
    	}
    	
    	if (WOI != null)
    	{
    		//m = c.getCurrentWorkout();
    		//Sys.println("NEW WORKOUT SET(" + WOI + "): " + m.getTitle());
    		Ui.requestUpdate();
    	}
    }

    function onMenu() {
        //Ui.pushView(new Rez.Menus.MainMenu(), new iqMenuDelegate(), Ui.SLIDE_UP);
        return false;
    }

}