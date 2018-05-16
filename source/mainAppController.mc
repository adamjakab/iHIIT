using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
//using ApeTools;

class mainAppController
{
	protected var workoutCount;
	protected var currentWorkout;
	
	
	var finish_workout_option;

	// Initialize the controller
    public function initialize() {
    	workoutCount = ApeTools.WorkoutHelper.getWorkoutCount();
    	Sys.println("Workout count: " + workoutCount);
    	
    	currentWorkout = new $.workout(1);
    
    	finish_workout_option = 0;
    }
    
    
	/*
     * Start the selected workout
     */
    function beginCurrentWorkout() {
    	if(!currentWorkout.isNotStarted())
    	{
    		Sys.println("CTRL - START REFUSED - Current workout must be in stopped state to be started");
    		return;
    	}
    	Sys.println("CTRL - START");

		currentWorkout.startRecording();
		Ui.pushView(new doWorkoutView(), new doWorkoutDelegate(), Ui.SLIDE_UP);
    }
        
    /*
     * Stop workout
     */
    function stop() {
		if(currentWorkout.isTerminated())
		{
			Ui.pushView(new finishWorkoutView(), new finishWorkoutDelegate(), Ui.SLIDE_UP);
			return;
		}
		
    	if(!currentWorkout.isRunning())
    	{
    		Sys.println("CTRL - STOP REFUSED - Current workout must be running to be stoped");
    		return;
    	}
    	
		Sys.println("CTRL - STOP");
		currentWorkout.stopRecording();
    }
    
    /*
     * Resume workout
     */
    function resume() {
    	if(currentWorkout.isTerminated())
		{
			Sys.println("CTRL - RESUME REFUSED - Workout already finished");
			return;
		}
	
		Sys.println("CTRL - RESUME");
		currentWorkout.startRecording();
		Ui.popView(Ui.SLIDE_DOWN);
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
		model.discardRecording();
       	
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