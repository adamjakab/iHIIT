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
	private var workout_index;
	private var title;

	private var session;
	private var session_started = false;
	
	private var workout_timer;
	
	private var workout_elapsed_seconds;
	
	private var current_exercise;
	private var exercise_count;
	
	
	// Initialize
	// @param WOI - Workout index
    function initialize(WOI)
    {
    	self.workout_index = WOI;
    	self.title = ApeTools.WorkoutHelper.getPropertyForWorkout(self.workout_index, "title", "");
 
    	self.exercise_count = ApeTools.ExerciseHelper.getExerciseCount(self.workout_index);
    	self.current_exercise = 0;
    	self.workout_elapsed_seconds = 0;    	
    	Sys.println("Exercise count[WOI:"+self.workout_index+"]: " + exercise_count);
    	
    	self.workout_timer = new Timer.Timer();
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
    	if(!isRecording())
    	{
    		session.start();
    		if(!isSessionStarted())
    		{
    			session_started = true;
    		}
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
    	if(session instanceof ActivityRecording.Session)
		{
			if(session.isRecording())
			{
				session.stop();
			}
			session_started = false;
			session.discard();
			session = null;
			Sys.println("MODEL - DISCARD");
		}
    }
    
    /*
     * Save recording
     */
    function saveRecording()
    {
    	if(session instanceof ActivityRecording.Session)
		{
			if(session.isRecording())
			{
				session.stop();
			}
			session_started = false;
			session.save();
			session = null;
			Sys.println("MODEL - SAVED");
		}
    }
    
    function isRecording()
    {
    	return session.isRecording();
    }
    
    function isSessionStarted()
    {
    	return session_started;
    }
    
    /*
     * Create a new recording session - discarding a previous one if necessary
     */
    function createNewSession()
    {
		discardRecording();
		
		exercise_duration_seconds = getPropertyForWorkout(selected_workout, "exercise_duration", 40);
    	rest_duration_seconds = getPropertyForWorkout(selected_workout, "rest_duration", 20);
    	exercise_elapsed_seconds = exercise_duration_seconds + 1;
    	
    	//Sys.println("eDUR: " + exercise_duration_seconds);
    	//Sys.println("rDUR: " + rest_duration_seconds);
		
		var session_name = getCurrentWorkoutName();
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
    
    function getExerciseCount() {
    	return self.exercise_count;
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