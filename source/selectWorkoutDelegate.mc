using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class selectWorkoutDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onKey( keyEvent )
    {
    	var m = App.getApp().model;
    	var c = App.getApp().controller;
    	var WO = null;
    	
    	var k = keyEvent.getKey();
    	if(k == Ui.KEY_DOWN) {
    		WO = m.setNextWorkout();
    	} else if (k == Ui.KEY_UP) {
    		WO = m.setPreviousWorkout();
    	} else if (k == Ui.KEY_ENTER) {
    		 c.startOrStop();
    	} else {
    		Sys.println("Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType());
    	}
    	
    	if (WO != null)
    	{
    		Sys.println("---NEW WORKOUT SET: " + WO);
    		Ui.requestUpdate();
    	}
    }

    function onMenu() {
        //Ui.pushView(new Rez.Menus.MainMenu(), new iqMenuDelegate(), Ui.SLIDE_UP);
        return false;
    }

}