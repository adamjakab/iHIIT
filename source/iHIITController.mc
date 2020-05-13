using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class iHIITController
{
	private var saveTimer;

	protected var maxWorkoutTestCount = 10;
	protected var currentWorkout;

	public var finish_workout_option;
	public var discardConfirmationSelection = 0;

	// Initialize the controller
    public function initialize(WOI)
    {
    	currentWorkout = new $.workout(WOI);
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
		initialize(currentWorkout.getWorkoutIndex());

       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
    }

    // Discard & go back to workout selection
	function discard_cancelled()
	{
       	Ui.popView(Ui.SLIDE_DOWN);
    }

    // Save
    public function save() {
		Sys.println("CTRL - SAVE");
		Ui.pushView(new saveWorkoutView(), new saveWorkoutDelegate(), Ui.SLIDE_UP);

		currentWorkout.saveRecording();

		saveTimer = new Timer.Timer();
    	saveTimer.start(method(:saveDone), 5000, false);
    }

    public function saveDone() {
    	if(saveTimer instanceof Timer.Timer)
		{
			saveTimer.stop();
			saveTimer = null;
		}
    	initialize(currentWorkout.getWorkoutIndex());

       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
    }

	//@todo: this method needs to be rewritten
    function setNextWorkout()
    {
    	var i;
    	var workoutFound = false;
    	var WOI = currentWorkout.getWorkoutIndex();

    	for (i = (WOI+1); i <= maxWorkoutTestCount; i++)
    	{
    		if(ApeTools.WorkoutHelper.isSelectableWorkout(i))
    		{
    			workoutFound = true;
    			currentWorkout = new $.workout(i);
    			break;
    		}
    	}

    	if(workoutFound == false)
    	{
    		for (i = 1; i <= WOI; i++)
    		{
    			if(ApeTools.WorkoutHelper.isSelectableWorkout(i))
	    		{
	    			workoutFound = true;
	    			currentWorkout = new $.workout(i);
	    			break;
	    		}
    		}
    	}

    	Sys.println("WORKOUT(" + currentWorkout.getWorkoutIndex() + ") SET TO: " + currentWorkout.getTitle());

    	return i;
    }

	//@todo: this method needs to be rewritten
    function setPreviousWorkout()
    {
    	var i;
    	var workoutFound = false;
    	var WOI = currentWorkout.getWorkoutIndex();

    	for (i = (WOI-1); i > 0; i--)
    	{
    		if(ApeTools.WorkoutHelper.isSelectableWorkout(i))
    		{
    			workoutFound = true;
    			currentWorkout = new $.workout(i);
    			break;
    		}
    	}

    	if(workoutFound == false)
    	{
    		for (i = maxWorkoutTestCount; i >= WOI; i--)
    		{
    			if(ApeTools.WorkoutHelper.isSelectableWorkout(i))
	    		{
	    			workoutFound = true;
	    			currentWorkout = new $.workout(i);
	    			break;
	    		}
    		}
    	}

    	Sys.println("WORKOUT(" + currentWorkout.getWorkoutIndex() + ") SET TO: " + currentWorkout.getTitle());

    	return i;
    }

    public function getCurrentWorkout()
    {
    	return currentWorkout;
    }

    // Handle timing out after exit
    public function onExit()
    {
        Sys.exit();
    }
}