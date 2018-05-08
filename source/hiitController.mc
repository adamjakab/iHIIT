using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


// Controls the UI flow of the app and controlls FIT recording
class hiitController
{
	var is_running;	
	var finish_workout_option;

	// Initialize the controller
    function initialize() {
    	is_running = false;
    	finish_workout_option = 0;
    }
    
    /*
     * Start or stop workout - do we really need this?
     */
    function startOrStop(forceStop) {
    	if(forceStop == true || isRunning())
    	{
    		stop();
    		Ui.pushView(new finishWorkoutView(), new finishWorkoutDelegate(), Ui.SLIDE_UP);
    	} else 
    	{
    		start();
    		Ui.pushView(new doWorkoutView(), new doWorkoutDelegate(), Ui.SLIDE_UP);
    	}
    }
    
	/*
     * Start workout
     */
    function start() {
    	is_running = true;		
       	Sys.println("CTRL - START");
       	
       	var m = App.getApp().model;
		m.startRecording();
    }
    
    /*
     * Resume workout
     */
    function resume() {
    	start();
    	
    	Ui.popView(Ui.SLIDE_DOWN);
       	Sys.println("CTRL - RESUME");
    } 
    
    /*
     * Stop workout
     */
    function stop() {
    	is_running = false;
       	Sys.println("CTRL - STOP");
       	
       	var m = App.getApp().model;
		m.stopRecording();
    }
    
    /*
     * Finish workout - decide how
     */
    function finishWorkout()
    {
    	if(finish_workout_option == 0) /* RESUME */
		{
			resume();
		} else if(finish_workout_option == 1) /* SAVE & EXIT */
		{
			save();
		} else if(finish_workout_option == 2) /* DISCARD & EXIT */
		{
			discard();
		} 
		
    }
    
    // Discard & go back to workout selection
    function discard() {
    	var m = App.getApp().model;
		m.discardRecording();
		m.createNewSession();
		
       	Sys.println("CTRL - DISCARD");
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	//Sys.exit();
    }
    
    // Save
    function save() {
    	var m = App.getApp().model;
		m.saveRecording();
		m.createNewSession();
		
       	Sys.println("CTRL - SAVE");
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
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