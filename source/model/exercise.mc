using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Math as Math;
using Toybox.WatchUi as Ui;

/**
 * Model: exercise
 */
class exercise
{
	const DEFAULT_EXERCISE_DURATION = 40;
	const DEFAULT_REST_DURATION = 20;
	
	private var workout_index;
	private var exercise_index;
	
	private var title;
	private var exercise_duration;
	private var rest_duration;
	
	private var exercise_timer;	
	private var exercise_elapsed;
	
	// Initialize
	// @param WOI - Workout index
	// @param EI -  Exercise index
    function initialize(WOI, EI)
    {
    	self.workout_index = WOI;
    	self.exercise_index = EI;
    	
    	self.title = ApeTools.ExerciseHelper.getPropertyForWorkoutExcercise(self.workout_index, self.exercise_index, "title", "");
    	self.exercise_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "exercise_duration", exercise.DEFAULT_EXERCISE_DURATION);
    	self.rest_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "rest_duration", exercise.DEFAULT_REST_DURATION);
    	
    	self.exercise_timer = new Timer.Timer();
    	self.exercise_elapsed = 0;
    	
    	Sys.println("EXERCISE created["+EI+"]: " + self.title);
    }

	function start()
	{
		Sys.println("EXERCISE - START");
		self.exercise_timer.start( method(:exerciseTimerCallback), 1000, true );
	}
	
	function stop()
	{
		Sys.println("EXERCISE - STOP");
		self.exercise_timer.stop();
	}

	function exerciseTimerCallback() 
	{
	 	self.exercise_elapsed++;
	 	
	 	if(isExerciseTimeFinished())
	 	{
	 		self.exercise_timer.stop();
	 		self.exercise_timer = null;
	 		App.getApp().getController().getCurrentWorkout().setNextExercise(true);
	 	}
 	} 	
 	
 	
 	//--------------------------------------------------------------------------GETTERS
 	function isItRestTime()
 	{
 		return self.exercise_elapsed > self.exercise_duration;
 	}
 	
 	function isExerciseTimeFinished()
 	{
 		return self.exercise_elapsed > self.exercise_duration + self.rest_duration;
 	}
 	
 	function getRestElapsedSeconds()
 	{
 		return isItRestTime() ? self.exercise_elapsed - self.exercise_duration : 0;
 	}
 	
 	function getRestRemainingSeconds()
 	{
 		return self.rest_duration - getRestElapsedSeconds();
 	}
 	
 	function getExerciseElapsedSeconds()
 	{
 		return isItRestTime() ? self.exercise_duration : self.exercise_elapsed;
 	}
 	
 	function getExerciseRemainingSeconds()
 	{
 		return self.exercise_duration - getExerciseElapsedSeconds();
 	}
 	
    
	function getWorkoutIndex() {
    	return self.workout_index;
    }
    
    function getExerciseIndex() {
    	return self.exercise_index;
    }
    
    function getTitle() {
    	return self.title;
    }
    
}