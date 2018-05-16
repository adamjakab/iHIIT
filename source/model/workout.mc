using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Math as Math;
using Toybox.ActivityRecording as ActivityRecording;
using Toybox.WatchUi as Ui;

/**
 * Model: workout
 */
class workout
{
	const STATE_NOT_STARTED = 0;
	const STATE_RUNNING = 1;
	const STATE_PAUSED = 2;
	const STATE_TERMINATED = 3;
	
	private var workout_index;
	private var title;
	private var exercise_duration;
	private var rest_duration;
	
	private var state = STATE_NOT_STARTED;

	private var session;
	//private var session_started = false;
	
	private var workout_timer;
	
	private var workout_elapsed_seconds;
	
	private var current_exercise;
	private var exercise_count;
	
	
	// Initialize
	// @param WOI - Workout index
    function initialize(WOI)
    {
    	//self.state = self.STATE_NOT_STARTED;
    	
    	self.workout_index = WOI;
    	self.title = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "title", "");
    	self.exercise_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "exercise_duration", 40);
    	self.rest_duration = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "rest_duration", 20);
    	
    	
    	
    	self.exercise_count = ApeTools.ExerciseHelper.getExerciseCount(self.workout_index);
    	self.current_exercise = 0;
    	self.workout_elapsed_seconds = 0;    	
    	
    	Sys.println("STATE: " + self.state);
    	
    }
    

    
    function workoutTimerCallback() 
	{
	 	workout_elapsed_seconds++;		
	 	Ui.requestUpdate();
 	}
    
    
    /*
     * Start workout recording
     */
    function startRecording()
    {
    	if(self.state == self.STATE_NOT_STARTED)
    	{
    		createNewSession();
    		self.workout_timer = new Timer.Timer();
    	}
    	
    	if(self.state != self.STATE_RUNNING)
    	{
    		self.session.start();
    		self.state = self.STATE_RUNNING;    		
    		workout_timer.start( method(:workoutTimerCallback), 1000, true );
    		Sys.println("MODEL - REC");
    	}
    }
    
    /*
     * Stop workout recording
     */
    function stopRecording()
    {
    	if(isRecording())
    	{
    		session.stop();	
    		workout_timer.stop();
    		exercise_timer.stop();	
       		Sys.println("MODEL - STOP");
       	}
    }
    
    /*
     * Discard recording
     */
    function discardRecording()
    {
    	if(self.session instanceof ActivityRecording.Session)
		{
			if(self.session.isRecording())
			{
				self.session.stop();
			}
			self.session.discard();
			self.session = null;
			self.state = self.STATE_TERMINATED;
			Sys.println("MODEL - DISCARD");
		}
    }
    
    /*
     * Save recording
     */
    function saveRecording()
    {
    	if(self.session instanceof ActivityRecording.Session)
		{
			if(self.session.isRecording())
			{
				self.session.stop();
			}
			self.session.save();
			self.session = null;
			self.state = self.STATE_TERMINATED;
			Sys.println("MODEL - SAVED");
		}
    }
    
    
    /*
     * Create a new recording session - discarding a previous one if necessary
     */
    function createNewSession()
    {
		if(self.session instanceof ActivityRecording.Session)
		{
			Sys.println("MODEL - CANNOT CREATE NEW SESSION - ONE ALREADY EXISTS!");
			return;
		}		
		
		var session_name = self.title;
		var session_sport = ActivityRecording.SPORT_TRAINING;
		var session_sub_sport = ActivityRecording.SUB_SPORT_CARDIO_TRAINING;
		
		//SUB_SPORT_STRENGTH_TRAINING
		//SUB_SPORT_FLEXIBILITY_TRAINING
	    session = ActivityRecording.createSession({
	    	:name =>		session_name, 
	    	:sport =>		session_sport, 
	    	:subSport =>	session_sub_sport
	    });
    }
    
    
    //---------------------------------------------------------------------GETTERS
    function getWorkoutIndex() {
    	return self.workout_index;
    }
    
    function getTitle() {
    	return self.title;
    }
    
    function getExerciseDuration() {
    	return self.exercise_duration;
    }
    
    function getRestDuration() {
    	return self.rest_duration;
    }
    
    function getExerciseCount() {
    	return self.exercise_count;
    }
    
    function getState() {
    	return self.state;
    }
    
    function getCalculatedWorkoutDuration() {
    	var total = self.exercise_count * (self.exercise_duration + self.rest_duration);
    	var min = Math.floor(total / 60);
		var sec = total - (60 * min);
		return Lang.format("$1$:$2$", [min, sec]);
    }
    
   
    function isWorkoutFinished()
    {
    	return self.current_exercise > self.exercise_count;
    }
    
    function getElapsedSeconds(format)
    {
    	var answer = workout_elapsed_seconds;
    	if(format == true) {
    		var min = Math.floor(workout_elapsed_seconds / 60);
    		var sec = workout_elapsed_seconds - (60*min);
			answer = Lang.format("$1$:$2$", [min, sec]);
    	}
    	return answer;
    }
}