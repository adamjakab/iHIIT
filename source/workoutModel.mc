using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.ActivityRecording as ActivityRecording; //use to log activity
using Toybox.WatchUi as Ui;

/**
 * workoutModel
 * @todo: split into workout and exercise models
 */
class workoutModel
{
	private var session;
	private var session_started = false;
	
	private var max_workout;
	private var selected_workout;
	
	private var current_exercise;
	
	private var workout_timer;
	private var exercise_timer;
	
	private var workout_elapsed_seconds;
	private var exercise_elapsed_seconds;
	
	private var exercise_duration_seconds;
	private var rest_duration_seconds;
	
	
	// Initialize
    function initialize() {
    	selected_workout = 1;
    	current_exercise = 1;
    	setMaxWorkout();
    	
    	workout_elapsed_seconds = 0;
    	exercise_elapsed_seconds = 0;
    	
    	exercise_duration_seconds = 15;
    	rest_duration_seconds = 5;
    	
    	workout_timer = new Timer.Timer();
    	exercise_timer = new Timer.Timer();
    	
    	createNewSession();
    }
    
    
    function getCurrentExcerciseName()
    {
	    return getPropertyForWorkoutExcercise(selected_workout, current_exercise, "title");
    }
    
    function getCurrentWorkoutName()
    {
	    return getPropertyForWorkout(selected_workout, "title");
    }
    
    function getWorkoutElapsedSeconds()
    {
    	return workout_elapsed_seconds;
    }
    
    private function getPropertyForWorkoutExcercise(workout_number, exercise_number, attribute_name)
    {
		var property_id = Lang.format("workout_$1$_exercise_$2$_$3$", [workout_number, exercise_number, attribute_name]);
	    var property_value = App.getApp().getProperty(property_id);
	    if(property_value == null || property_value == "") {
				property_value = false;
			}
	    return property_value;
    }
    
    private function getPropertyForWorkout(workout_number, attribute_name)
    {
		var property_id = Lang.format("workout_$1$_$2$", [workout_number, attribute_name]);
	    var property_value = App.getApp().getProperty(property_id);
	    if(property_value == null || property_value == "") {
				property_value = false;
			}
	    return property_value;
    }
    
    
    function workoutTimerCallback() 
	{
	 	workout_elapsed_seconds++;		
	 	Ui.requestUpdate();
 	}
    
    function exerciseTimerCallback() 
	{
	 	exercise_elapsed_seconds++;
	 	if(exercise_elapsed_seconds >= exercise_duration_seconds)
	 	{
	 		exercise_elapsed_seconds = 0;
	 		//@todo: make method for incrementing this
	 		current_exercise++;
	 		Ui.requestUpdate();
	 	}
	 	//Ui.requestUpdate();
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
    		exercise_timer.start( method(:exerciseTimerCallback), 1000, true );
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

		var session_name = "HiiTiT - WO: " + selected_workout;
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
    
    
    
    function getSelectedWorkout() {
    	return selected_workout;
    }
    
    function setNextWorkout() {
    	selected_workout++;
    	if(selected_workout > max_workout)
    	{
    		selected_workout = 1;
    	}    	
    	createNewSession();
    	
    	return getSelectedWorkout();
    }
    
    function setPreviousWorkout() {
    	selected_workout--;
    	if(selected_workout < 1)
    	{
    		selected_workout = max_workout;
    	}    	
    	createNewSession();
    	
    	return getSelectedWorkout();
    }
    
    private function setMaxWorkout()
    {
    	var app = App.getApp();    	
		for (var i=1; i<10; i++) {
			var title_key = "workout_" + i + "_title";
	        var workout_title = app.getProperty(title_key);
			if(workout_title != null && workout_title != "") {
				max_workout = i;
			}
		}
    }
}