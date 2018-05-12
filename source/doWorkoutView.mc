using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention; //used for vibration

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
         Sys.println("DOWORKOUT - INIT");
         
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
    	//refreshTimer.start( method(:refreshTimerCallback), 1000, true );
    	
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
    	var m = App.getApp().getController().getModel();
    	if (m.isWorkoutFinished())
    	{
    		updateWorkoutFinished(dc);
    	} else {
    		updateWorkoutRunning(dc);
    	}
    }
    
    function updateWorkoutFinished(dc)
    {
    	var m = App.getApp().getController().getModel();
    	var txt;
    	var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
    	//** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
    	txt = "WELL DONE!";
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(centerX, centerY - 12, Gfx.FONT_LARGE, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        txt = "Total time: " + m.getWorkoutElapsedSeconds(true);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
        dc.drawText(centerX, centerY + 20, Gfx.FONT_MEDIUM, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function updateWorkoutRunning(dc)
    {    
        var txt, text_height, x, y, width, height, margin, color;
        var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
        var m = App.getApp().getController().getModel();
        var WO = m.getSelectedWorkout();
        
        var is_resting = m.isItRestTime();
        
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        
        //CENTER BOX
        text_height = 24;
        margin = 5;
        y = centerY - (text_height/2) - margin;
        height = text_height + (margin * 2);
        color = is_resting ? Gfx.COLOR_DK_GREEN : Gfx.COLOR_ORANGE;
        dc.setColor(color, Gfx.COLOR_BLACK);
        dc.drawRectangle(0, y, screen_width, height);

		//CENTER TEXT - CURRENT EXERCISE
		txt = m.getCurrentExcerciseName();
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
        txt = is_resting ? "coming up" : "exercise";
        y = y - 3;
        //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, y, Gfx.FONT_XTINY, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //REMAINING TIME
        txt = is_resting ? m.getRestRemainingSeconds() : m.getExerciseRemainingSeconds();
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerX + 10, Gfx.FONT_NUMBER_HOT, txt, Gfx.TEXT_JUSTIFY_CENTER);
        

    }
    
}