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
    public function initialize()
    {
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
    public function save() {
    	var str_activity_saving = Ui.loadResource(Rez.Strings.activity_saving);
    	var str_activity_saved = Ui.loadResource(Rez.Strings.activity_saved);

		Sys.println("CTRL - SAVE");

		var progressBar = new Ui.ProgressBar(str_activity_saving, null);
		Ui.pushView(progressBar, new saveWorkoutDelegate(), Ui.SLIDE_UP);

		currentWorkout.saveRecording();

		progressBar.setDisplayString(str_activity_saved);
		progressBar.setProgress(0);

		saveTimer = new Timer.Timer();
    	saveTimer.start(method(:saveDone), 3000, false);
    }

    public function saveDone() {
    	var WOI = currentWorkout.getWorkoutIndex();
		currentWorkout = new $.workout(WOI);

       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
       	Ui.popView(Ui.SLIDE_DOWN);
    }


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

    	return i;
    }

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