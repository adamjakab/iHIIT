using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
//using ApeTools;

class mainAppController
{
	protected var workoutCount;
	protected var currentWorkout;
	
	var is_running;	
	
	var finish_workout_option;

	// Initialize the controller
    function initialize() {
    	workoutCount = ApeTools.WorkoutHelper.getWorkoutCount();
    	Sys.println("Workout count: " + workoutCount);
    	
    	currentWorkout = new $.workout(1);
    
    	is_running = false;
    	finish_workout_option = 0;
    }
    
	/*
     * Start workout
     */
    function start() {
    	if(!isRunning())
    	{
	    	Sys.println("CTRL - START");
	    	is_running = true;
			var is_session_started = model.isSessionStarted();
			model.startRecording();
			if(!is_session_started)
			{
				Ui.pushView(new doWorkoutView(), new doWorkoutDelegate(), Ui.SLIDE_UP);
			}
    	} else
    	{
    		Sys.println("CTRL - START REFUSED - Already running");
    	}
    }
        
    /*
     * Stop workout
     */
    function stop() {
    	if(isRunning())
    	{
    		Sys.println("CTRL - STOP");
    		is_running = false;
			model.stopRecording();
			if(!model.isWorkoutFinished())
			{
				Ui.pushView(new finishWorkoutView(), new finishWorkoutDelegate(), Ui.SLIDE_UP);
			}			
		} else 
		{
			Sys.println("CTRL - STOP REFUSED - Already stoped");
			if(model.isWorkoutFinished())
			{
				Ui.pushView(new finishWorkoutView(), new finishWorkoutDelegate(), Ui.SLIDE_UP);
			}
		}
    }
    
    /*
     * Resume workout
     */
    function resume() {
    	if(!model.isWorkoutFinished())
    	{
    		Sys.println("CTRL - RESUME");
    		start();
    		Ui.popView(Ui.SLIDE_DOWN);
    	} else 
    	{
    		Sys.println("CTRL - RESUME REFUSED - Workout already finished");
    	}
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
		Sys.println("CTRL - DISCARD");
		//@todo: we need confirmation for this
		model.createNewSession();
       	
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	//Sys.exit();
    }
    
    // Save
    function save() {
		Sys.println("CTRL - SAVE");
		model.saveRecording();
		model.createNewSession();
       	
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
    }
    
    // Are we running currently?
    function isRunning() {
       	return is_running;
    }
    
    function setNextWorkout()
    {
    	var WOI = currentWorkout.getWorkoutIndex();
    	WOI++;
    	if(WOI > workoutCount)
    	{
    		WOI = 1;
    	}
    	
    	currentWorkout = new $.workout(WOI);
    	
    	return WOI;
    }
    
    function setPreviousWorkout()
    {
    	var WOI = currentWorkout.getWorkoutIndex();
    	WOI--;
    	if(WOI < 1)
    	{
    		WOI = workoutCount;
    	}
    	
    	currentWorkout = new $.workout(WOI);
    	
    	return WOI;
    }
    
    // Renamed from getModel
    public function getCurrentWorkout()
    {
    	return currentWorkout;
    }
    
    // Handle timing out after exit
    function onExit() {
        Sys.exit();
    }
}