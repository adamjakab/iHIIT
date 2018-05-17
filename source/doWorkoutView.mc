using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention;

class doWorkoutView extends Ui.View
{
	private var refreshTimer;
	private var timerCount = 0;
	
	private var screen_width;
	private var screen_height;
	
	private var vibeDataStart = [
	    new Attention.VibeProfile(  75, 500 ),
	    new Attention.VibeProfile(  0, 500 ),
	    new Attention.VibeProfile(  75, 500 ),
	    new Attention.VibeProfile(  0, 500 ),
	    new Attention.VibeProfile( 	100, 1000 )
	];

    function initialize() {
        View.initialize();
        
        refreshTimer = new Timer.Timer();
        timerCount = 0;        
        
        //record_prop = app.getProperty("record_prop");
         Sys.println("DO-WORKOUT-VIEW - INIT");
         
    }
    
    // Load your resources here
    function onLayout(dc) {
    	screen_width = dc.getWidth();
    	screen_height = dc.getHeight();
    }
    
    function refreshTimerCallback() 
	{
	 	timerCount++;		
	 	Ui.requestUpdate();
 	}
 	
    function onShow() {
    	refreshTimer.start( method(:refreshTimerCallback), 1000, true );
    	
    	if (Attention has :playTone) {
		   //Attention.playTone(Attention.TONE_START);
		}
		
		if (Attention has :vibrate) {
			Attention.vibrate(vibeDataStart);
		}
    }
    
    function onHide() 
    {
	    refreshTimer.stop();
    }
    
    // Update the view
    function onUpdate(dc) {
    	var currentWorkout = App.getApp().getController().getCurrentWorkout();
    	
    	if (currentWorkout.isTerminated())
    	{
    		updateWorkoutTerminated(dc);
    	} else if (currentWorkout.isRunning())
    	{
    		var currentExercise = currentWorkout.getCurrentExercise();
    		if(currentExercise.isItRestTime())
    		{
    			updateWorkoutResting(dc);
    		} else {
    			updateWorkoutExercising(dc);
    		}
    	} else {
    		Sys.println("Workout view - workout is in an invalid state: " + currentWorkout.getState());
    	}
    }
    
    protected function updateWorkoutExercising(dc)
    {
        var txt, text_height, x, y, width, height, margin, color;
        var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
        var currentWorkout = App.getApp().getController().getCurrentWorkout();
        var currentExercise = currentWorkout.getCurrentExercise();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        color = Gfx.COLOR_ORANGE;
        
        //REMAINING TIME
        txt = currentExercise.getExerciseRemainingSeconds();
        text_height = Gfx.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT);
        x = centerX;
        y = centerY - (text_height / 2) - 20;
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y, Gfx.FONT_NUMBER_THAI_HOT, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
		//CENTER TEXT - CURRENT EXERCISE
		txt = currentExercise.getTitle();
		x = centerX;
		y = centerY + (text_height / 2) - 30;
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y, Gfx.FONT_SYSTEM_SMALL, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        y = centerY + (text_height / 2) - 30;
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(0, y, screen_width, y);
    }
    
    
    protected function updateWorkoutResting(dc)
    {
        var txt, text_height, x, y, width, height, margin, color;
        var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
        var currentWorkout = App.getApp().getController().getCurrentWorkout();
        var currentExercise = currentWorkout.getCurrentExercise();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        //CENTER BOX
        text_height = 24;
        margin = 5;
        y = centerY - (text_height/2) - margin;
        height = text_height + (margin * 2);
        color = Gfx.COLOR_DK_GREEN;
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawRectangle(0, y, screen_width, height);

		//CENTER TEXT - NEXT EXERCISE
		txt = currentExercise.getTitle();
		y = centerY - (text_height/2);
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_SYSTEM_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //SMALL CENTER BOX
        width = 100;
        height = 16;
        x = centerX - (width/2);
        y = centerY - (text_height/2) - margin - height + 1;
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, width, height);
        
        //SMALL CENTER TEXT
        txt = "coming up";
        y = y - 3;
        dc.drawText(centerX, y, Gfx.FONT_XTINY, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //REMAINING TIME
        txt = currentExercise.getRestRemainingSeconds();
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 10, Gfx.FONT_NUMBER_HOT, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    protected function updateWorkoutTerminated(dc)
    {
    	var workout = App.getApp().getController().getCurrentWorkout();
    	var txt;
    	var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
    	//** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
    	txt = "WELL DONE!";
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(centerX, centerY - 12, Gfx.FONT_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        txt = "Total time: " + workout.getElapsedSeconds(true);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
        dc.drawText(centerX, centerY + 20, Gfx.FONT_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
}