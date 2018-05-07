using Toybox.Application as App;
using Toybox.System as Sys;

class hiitModel
{
	private var max_workout;
	private var selected_workout;
	
	// Initialize
    function initialize() {
    	selected_workout = 1;
    	setMaxWorkout();
    	
    	Sys.println("MDL(maxWrk): " + max_workout);
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
    	return getSelectedWorkout();
    }
    
    function setPreviousWorkout() {
    	selected_workout--;
    	if(selected_workout < 1)
    	{
    		selected_workout = max_workout;
    	}
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