using Toybox.Timer;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class mainAppController
{
	protected var workoutCount;
	protected var currentWorkout;
	
	public var discardConfirmationSelection = 0;
	
	
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
    		Sys.println("CTRL - START REFUSED - Workout must be in stopped state to be started");
    		return;
    	}
    	Sys.println("CTRL - START");

		currentWorkout.startRecording();
		Ui.pushView(new doWorkoutView(), new doWorkoutDelegate(), Ui.SLIDE_UP);
    }
        
    /*
     * Stop workout
     * This is also called after Workout reaches last exercise and auto-terminates
     */
    function stop() {
    	if(!currentWorkout.isRunning() && !currentWorkout.isTerminated())
    	{
    		Sys.println("CTRL - STOP REFUSED - Workout must be running or terminated");
    		return;
    	}
    	
    	Sys.println("CTRL - STOP");
    	if(currentWorkout.isRunning())
    	{
    		currentWorkout.stopRecording();
    	}		
		Ui.pushView(new finishWorkoutView(), new finishWorkoutDelegate(), Ui.SLIDE_UP);
    }
    
    /*
     * Resume workout
     */
    function resume() {
    	if(!currentWorkout.isPaused())
		{
			Sys.println("CTRL - RESUME REFUSED - Workout must be paused to be resumed");
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
    
    // Discard - Ask confirmation
    function discard() {
		Sys.println("CTRL - DISCARD");
		Ui.pushView(new discardConfirmationView(), new discardConfirmationDelegate(), Ui.SLIDE_UP);
	}
	
	// Discard & go back to workout selection
	function discard_confirmed()
	{	
		currentWorkout.discardRecording();
		var WOI = currentWorkout.getWorkoutIndex();
		currentWorkout = new $.workout(WOI);
       	
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	//Sys.exit();
    }
    
    // Discard & go back to workout selection
	function discard_cancelled()
	{	
       	Ui.popView(Ui.SLIDE_DOWN);
    }
    
    // Save
    function save() {
		Sys.println("CTRL - SAVE");
		
		currentWorkout.saveRecording();
		
		var WOI = currentWorkout.getWorkoutIndex();
		currentWorkout = new $.workout(WOI);
       	
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