using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.ActivityRecording as ActivityRecording; //use to log activity

class hiitModel
{
	private var max_workout;
	private var selected_workout;
	private var session;
	
	// Initialize
    function initialize() {
	    /*if( ! Toybox has :ActivityRecording)
	    {
		    Sys.error("This device is not capable of activity recording!");
	    }*/
    	selected_workout = 1;
    	setMaxWorkout();
    	createNewSession();
    }
    
    /*
     * Start workout recording
     */
    function startRecording()
    {
    	if(!isRecording())
    	{
    		session.start();
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
			session.save();
			session = null;
			Sys.println("MODEL - SAVED");
		}
    }
    
    /*
     * Stop workout recording
     */
    function isRecording()
    {
    	return session.isRecording();
    }
    
    /*
     * Create a new recording session - discarding a previous one if necessary
     */
    function createNewSession()
    {
		discardRecording();

		var session_name = "HiIt - WO: " + selected_workout;
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