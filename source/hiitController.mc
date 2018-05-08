using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityRecording as ActivityRecording; //use to log activity

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
    	
    	/*
    	if( Toybox has :ActivityRecording && record_prop == true ) 
    	{
    		//SUB_SPORT_STRENGTH_TRAINING
    		//SUB_SPORT_FLEXIBILITY_TRAINING
            session = ActivityRecording.createSession({
            	:name=>"WorkItOut", 
            	:sport=>ActivityRecording.SPORT_TRAINING, 
            	:subSport=>ActivityRecording.SUB_SPORT_CARDIO_TRAINING
            });
            session.start();
		}
		*/
		
       	Sys.println("CTRL - START");
    }
    
    /*
     * Stop workout
     */
    function stop() {
    	is_running = false;
       	Sys.println("CTRL - STOP");
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
    
    /*
     * Resume workout
     */
    function resume() {
    	is_running = true;
    	Ui.popView(Ui.SLIDE_DOWN);
       	Sys.println("CTRL - RESUME");
    }    
    
    // Discard & go back to 
    function discard() {
       	Sys.println("CTRL - DISCARD");
       	Sys.exit();
    }
    
    // Save
    function save() {
       	Sys.println("CTRL - SAVE");
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