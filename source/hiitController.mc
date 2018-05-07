//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// Controls the UI flow of the app and controlls FIT recording
class hiitController
{
	var is_running;

	// Initialize the controller
    function initialize() {
    	is_running = false;
    }
    
    
    function startOrStop(forceStop) {
    	if(forceStop == true || isRunning())
    	{
    		stop();
    		WatchUi.pushView(new Rez.Menus.finishWorkoutMenu(), new finishWorkoutDelegate(), WatchUi.SLIDE_UP);
    	} else 
    	{
    		start();
    		Ui.pushView(new doWorkoutView(), new doWorkoutDelegate(), Ui.SLIDE_UP);
    	}
    }
    
	// Start the recording process
    function start() {
    	is_running = true;
       	Sys.println("CTRL - START");
    }
    
    // Stop the recording process
    function stop() {
    	is_running = false;
       	Sys.println("CTRL - STOP");
    }
    
    function resume() {
    	is_running = true;
       	Sys.println("CTRL - RESUME");
    }
    
    // Save
    function save() {
       	Sys.println("CTRL - SAVE");
    }
    
    // Discard
    function discard() {
       	Sys.println("CTRL - DISCARD");
    }
    
    // Are we running currently?
    function isRunning() {
       	return is_running;
    }

    // Handle timing out after exit
    function onExit() {
        Sys.exit();
    }
}