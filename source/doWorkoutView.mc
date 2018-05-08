using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class doWorkoutView extends Ui.View {

	var dataTimer;
	var timerCount = 0;

    function initialize() {
        View.initialize();
        
        timerCount = 0;
        
        var app = App.getApp();
        //record_prop = app.getProperty("record_prop");
        
         Sys.println("DOWORKOUT - INIT");
    }
    
    // Load your resources here
    function onLayout(dc) {        
		dataTimer = new Timer.Timer();
        dataTimer.start( method(:timerCallback), 1000, true );
    }
    
    function timerCallback() 
	{
	 	timerCount++;	 		
	 	Ui.requestUpdate();
 	}
 	
    function onShow() {
    	dataTimer.start( method(:timerCallback), 1000, true );
    }
    
    function onHide() 
    {
	    dataTimer.stop();
    }
    
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        
        var txt;
        
        var app = App.getApp();
        var m = app.model;
        var WO = m.getSelectedWorkout();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear(); 
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        txt = "RUNNING...";
        dc.drawText(width/2, height/2, Gfx.FONT_TINY, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //COUNTER
        dc.drawText(width/2, 0, Gfx.FONT_SYSTEM_XTINY, timerCount, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
}