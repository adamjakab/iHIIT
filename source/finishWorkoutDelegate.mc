using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class finishWorkoutDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	var c = App.getApp().controller;
        
        if (item == :resume) {
            Sys.println("RESUME");
            c.resume();
        } else if (item == :save_and_exit) {
            Sys.println("SAVE + EXIT");
        } else if (item == :discard_and_exit) {
            Sys.println("DISCARD + EXIT");
        }
    }
    
    function onKey( keyEvent )
    {
    	var m = App.getApp().model;
    	var c = App.getApp().controller;
    	var WO = null;
    	
    	var k = keyEvent.getKey();
    	if (k == Ui.KEY_ESC) {
    		c.resume();
    		return false;
    	} else {
    		Sys.println("Unused Key press: " + keyEvent.getKey() + " / " + keyEvent.getType());
    	}
    	
    }

	function onMenu() {
        return false;
    }
}
